# frozen_string_literal: true
require 'will_paginate/array'
class RentalsController < ApplicationController
  @per_page = 10

  before_action :set_rental, only: [:show, :update, :destroy, :transform, :invoice]
  before_action :set_item_types, only: [:index, :new, :create, :update, :processing]
  before_action :set_items, only: [:index, :new, :create, :update, :processing]
  before_action :set_all_users, only: [:index, :processing]
  before_action :set_incidental_types, only: [:new]
  before_action :set_financial_transactions, only: [:show, :invoice]

  after_action :set_return_url, only: [:index, :processing]

  # GET /rentals
  def index
    # first pull out the rentals that match our two fields that are not done through ransack
    # (because arel is honestly just too complicated)
    base_search_area = rentals_visible_to_current_user.joins(:rentals_items)
    if params[:item_type_id_in].present?
      base_search_area = base_search_area.where('rentals_items.item_type_id' => params.permit(item_type_id_in: []).fetch(:item_type_id_in))
    end
    if params[:item_id_in].present?
      base_search_area = base_search_area.where('rentals_items.item_id' => params.permit(item_id_in: []).fetch(:item_id_in))
    end
    # this probably isnt the most efficient way to do it

    @q = base_search_area.search(params[:q])
    @rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
    gon.reservations = Rental.to_json_reservations
  end

  # GET /rentals/cost?end_time=time&start_time=time&item_types=...
  def cost
    cost_params = params.permit(:start_time, :end_time, item_types: [])
    required_params = %w(start_time end_time item_types)
    if (cost_params.to_h.keys & required_params) == required_params
      start_time = Time.zone.parse(cost_params[:start_time]).to_date.to_s
      end_time = Time.zone.parse(cost_params[:end_time]).to_date.to_s

      begin
        cost = cost_params[:item_types].each_with_object({}) do |it_id, acc|
          it = ItemType.find_by(id: it_id)
          if it
            acc[it.name] ||= 0
            acc[it.name] += it.cost(start_time, end_time)
          else
            raise ArgumentError, it_id
          end
        end
      rescue => err
        render json: { errors: ["item not found #{err.message}"] }, status: 400 and return
      end

      render json: cost.merge(_total: cost.values.reduce(:+))
    else
      render status: 400,
             json: { errors:
                       ["missing_params: #{(required_params - cost_params.to_h.keys).inject('') { |acc, part| acc.blank? ? part.to_s : "#{acc}, #{part}" }}"] }
    end
  end

  # GET /rentals/new
  def new
    # conditionally assign because it could be set already by a method that calls this one
    @rental ||= Rental.new
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
    # first pull out the rentals that match our two fields that are not done through ransack
    # (because arel is honestly just too complicated)
    base_search_area = rentals_visible_to_current_user.joins(:rentals_items)
    if params[:item_type_id_in].present?
      base_search_area = base_search_area.where('rentals_items.item_type_id' => params.permit(item_type_id_in: []).fetch(:item_type_id_in))
    end
    if params[:item_id_in].present?
      base_search_area = base_search_area.where('rentals_items.item_id' => params.permit(item_id_in: []).fetch(:item_id_in))
    end
    # this probably isnt the most efficient way to do it

    @q = base_search_area.search(params[:q])
    @rentals = @q.result(distinct: true)
                 .where('start_time >= ? AND start_time <= ?',
                        Time.current.beginning_of_day,
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
      flash[:danger] = "This rental is in the '#{@rental.rental_status}' state and cannot be processed"
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

    # if the specified a custom amount we will create the financial transactions later
    rental.skip_financial_transactions = params[:amount] && rental.cost != params[:amount] &&
                                         @current_user.has_permission?('rentals', 'cost_adjustment')

    if rental.save
      # use that special pricing, we already verified their perms
      if rental.skip_financial_transactions
        # create a single custom financial transaction for entire rental
        FinancialTransaction.create rental: rental, transactable_type: Rental.name,
                                    transactable_id: rental.id, amount: params[:amount],
                                    note_field: "custom rental pricing by #{@current_user.full_name} (#{@current_user.id})"
      end # else use default pricing

      flash[:success] = 'Rental successfully Reserved'
      redirect_to rental
    else
      flash[:danger] = 'Failed to reserve Rental'
      flash[:warning] = rental.errors.full_messages
      @rental = rental
      redirect_to action: :new
    end
  end

  # DELETE /rentals/1
  def destroy
    if @rental.may_cancel?
      @rental.cancel!
      flash[:success] = 'Rental successfully Canceled'
    elsif @rental.canceled?
      flash[:warning] = 'Rental has already been Canceled'
    else
      flash[:warning] = "This rental is in the '#{@rental.rental_status}' state and cannot be canceled"
    end
    redirect_back(fallback_location: rentals_path)
  end

  private

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
    render_401 and return unless rentals_visible_to_current_user.include? @rental
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
    renter = User.find_by id: params.require(:rental).require(:renter_id)
    new_time = Time.zone.parse(params[:rental][:end_time]).end_of_day
    params.require(:rental).permit(:start_time, :pickup_name, :dropoff_name,
                                   :pickup_phone_number, :dropoff_phone_number,
                                   rentals_items_attributes: [:item_type_id]).merge(renter: renter, end_time: new_time)
  end
end
