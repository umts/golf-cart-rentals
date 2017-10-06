# frozen_string_literal: true
require 'will_paginate/array'
class RentalsController < ApplicationController
  @per_page = 10

  before_action :set_rental, only: [:show, :edit, :update, :destroy, :transform, :invoice]
  before_action :set_item_types, only: [:index, :new, :create, :edit, :update, :processing]
  before_action :set_items, only: [:index, :new, :create, :edit, :update, :processing]
  before_action :set_all_users, only: [:index, :processing]
  before_action :set_incidental_types, only: [:new]
  before_action :set_financial_transactions, only: [:show, :invoice]

  after_action :set_return_url, only: [:index, :processing]

  # GET /rentals
  def index
    @q = rentals_visible_to_current_user.search(params[:q])
    @rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)

    gon.reservations = Rental.to_json_reservations
  end

  # GET /rentals/1
  def show; end

  # GET /rentals/cost?end_time=time&start_time=time&item_types=...
  def cost
    _params = cost_params
    required_params = %w(start_time end_time item_types)
    if (_params.to_h.keys & required_params) == required_params
      start_time = Time.zone.parse(_params[:start_time]).to_date.to_s
      end_time = Time.zone.parse(_params[:end_time]).to_date.to_s

      cost = {}
      begin
        cost = Hash[_params[:item_types].map do |it_id|
          if it = ItemType.find_by_id(it_id)
            [it.name, it.cost(start_time, end_time)]
          else
            raise ArgumentError, it_id
          end
        end]
      rescue => err
        render json: {errors: [ "item not found #{err.message}" ]}, status: 400 and return
      end

      render json: cost.merge(_total: cost.values.reduce(:+))
    else
      render status: 400, json: { errors: [
        "missing_params: #{(required_params - _params.to_h.keys).inject('') { |acc, part| if acc.blank? then "#{part}" else "#{acc}, #{part}" end }}"
      ]}
    end
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
    @start_date = params['start_date'].try(:to_date) || Time.zone.today
    @admin_status = @current_user.has_group? Group.where(name: 'admin')
    set_users_to_assign
  end

  # Send safety pdf to client
  def safety_pdf
    send_file(
      Rails.root.join('app', 'assets', 'pdfs', 'Golf-Cart-Safety.pdf'),
      filename: 'Golf Cart Safety.pdf',
      type: 'application/pdf'
    )
  end

  # Send training pdf to client
  def training_pdf
    send_file(
      Rails.root.join('app', 'assets', 'pdfs', 'Golf-Cart-Training-User-Agreement.pdf'),
      filename: 'Golf Cart Training User Agreement',
      type: 'application/pdf'
    )
  end

  # GET /rentals/processing
  def processing
    @q = rentals_visible_to_current_user.search(params[:q])
    @rentals = @q.result(distinct: true).where('start_time >= ? AND start_time <= ?', Time.current.beginning_of_day,
                                               Time.current.end_of_day).paginate(page: params[:page], per_page: @per_page)
  end

  # GET /rentals/1/transform
  def transform
    if @rental.reserved? && @rental.end_date < DateTime.current
      render :no_show_form, locals: { rental: @rental }
    elsif @rental.reserved?
      render :pickup, locals: { rental: @rental }
    elsif @rental.picked_up?
      render :drop_off, locals: { rental: @rental }
    else
      flash[:danger] = 'Error Redirecting To Processing Form'
      render :index
    end
  end

  # PUT /rentals/1/
  def update
    if params[:commit] == 'Pick Up'
      if @rental.pickup
        pickup_name = params[:rental][:pickup_name]
        pickup_number = params[:rental][:pickup_phone_number]
        @rental.update!(pickup_name: pickup_name, pickup_phone_number: pickup_number)
      end
    elsif params[:commit] == 'Drop Off'
      if @rental.drop_off
        dropoff_name = params[:rental][:dropoff_name]
        dropoff_number = params[:rental][:dropoff_phone_number]
        @rental.update!(dropoff_name: dropoff_name, dropoff_phone_number: dropoff_number)
      end
    elsif params[:commit] == 'Process No Show'
      @rental.process_no_show
    else
      @rental.update rental_params
    end
    redirect_to @rental
  end

  # POST /rentals
  def create
    rental = Rental.new rental_params.merge(creator: @current_user)

    if rental.save
      if params[:amount] && @current_user.has_permission?('rentals', 'cost_adjustment')
        # TODO this needs to be changed to handle multiple rentals
        # find existing financial_transaction and change it
        financial_transaction = FinancialTransaction.find_by rental: rental, transactable_type: Rental.name, transactable_id: rental.id
        financial_transaction.amount = params[:amount]
        financial_transaction.save
      end # if they dont have permission ignore it and we will use default pricing
      flash[:success] = 'Rental Successfully Reserved'
      redirect_to(rental)
    else
      flash[:warning] = 'Item type is not available for specified dates' # TODO find out the actual error
      binding.pry
      rental.errors.full_messages.each { |e| flash_message :warning, e}
      redirect_to :new
    end
  end

  # DELETE /rentals/1
  def destroy
    if @rental.may_cancel?
      @rental.cancel!
      @rental.delete_reservation
      flash[:success] = 'Rental Canceled.'
    elsif @rental.canceled?
      flash[:warning] = 'Rental Has Already Been Canceled'
    else
      flash[:warning] = 'Rental Cannot Be Canceled'
    end
    redirect_back(fallback_location: rentals_path)
  end

  # GET /rentals/1/invoice
  def invoice; end

  private

  def cost_params
    params.permit(:start_time,:end_time, item_types: [])
  end

  def set_users_to_assign
    @users = @current_user.assignable_renters.map do |user|
      { id: user.id, tag: user.tag }
    end
  end

  def set_all_users
    @users = User.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = Rental.find(params[:id])
    render_401 && return unless rentals_visible_to_current_user.include? @rental
  end

  def set_financial_transactions
    @financial_transactions = FinancialTransaction.where(rental: @rental)
  end

  def set_item_types
    @item_types ||= ItemType.all.order(name: :asc)
    @item_types = @item_types.where(name: params['item_type']).order(name: :asc) if params['item_type']
  end

  def set_items
    @items = Item.all
  end

  def set_incidental_types
    @incidental_types = IncidentalType.all
  end

  # Only allow a trusted parameter "white list" through.
  def rental_params
    # tokeninput gives us an array, but find_by doesnt care it just gives us the first one
    renter = User.find_by_id params.require(:rental).require(:renter_id)
    new_time = Time.zone.parse(params[:rental][:end_time]).end_of_day
    params.require(:rental).permit(:start_time, :pickup_name, :dropoff_name,
                                   :pickup_phone_number, :dropoff_phone_number, rentals_items_attributes: [:item_type_id]).merge(renter: renter, end_time: new_time)
  end
end
