# frozen_string_literal: true
class RentalsController < ApplicationController
  @per_page = 10

  before_action :set_rental, only: [:show, :edit, :update, :destroy, :transform, :transaction_detail]
  before_action :set_item_types, only: [:index, :new, :create, :edit, :update, :processing]
  before_action :set_items, only: [:index, :new, :create, :edit, :update, :processing]
  before_action :set_users, only: [:index, :new, :processing, :transform]
  before_action :set_incidental_types, only: [:new]

  # GET /rentals
  def index
    @q = Rental.all.search(params[:q])
    @rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
    @users = User.all

    gon.reservations = Rental.to_json_reservations
  end

  # GET /Rental Financial Transaction Detail
  def transaction_detail
    @financial_transactions = FinancialTransaction.where(rental_id: @rental.id)
  end

  # GET /rentals/1
  def show
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
    @start_date = params['start_date'].try(:to_date) || Time.zone.today
    @admin_status = @current_user.has_group? Group.where(name: 'admin')
  end

  # GET /rentals/processing
  def processing
    @q = Rental.all.search(params[:q])
    @rentals = @q.result(distinct: true).where('start_time >= ? AND start_time <= ?', Time.current.beginning_of_day,
                                               Time.current.end_of_day).paginate(page: params[:page], per_page: @per_page)
  end

  # GET /rentals/1/transform
  def transform
    if @rental.reserved? && @rental.end_date < DateTime.current
      render :no_show_form, locals: { rental: @rental }
    elsif @rental.reserved?
      render :check_out, locals: { rental: @rental }
    elsif @rental.checked_out?
      render :check_in, locals: { rental: @rental }
    else
      flash[:danger] = 'Error redirecting to processing form'
      render :index
    end
  end

  # PUT /rentals/1/
  def update
    if params[:commit] == 'Check Out'
      DigitalSignature.create(image: sig_image_params, intent: :check_out, rental: @rental, author: :customer)
      @rental.pickup
    elsif params[:commit] == 'Check In'
      DigitalSignature.create(image: sig_image_params, intent: :check_in, rental: @rental, author: :customer)
      @rental.return
    elsif params[:commit] == 'Process No Show'
      @rental.process_no_show
    else
      @rental.update rental_params
    end
    redirect_to @rental
  end

  # POST /rentals
  def create
    @rental = Rental.new(rental_params)

    @start_date = params['start_date'] || Time.zone.today

    if @rental.create_reservation && @rental.save
      flash[:success] = 'You have succesfully reserved your Rental!'
      redirect_to(@rental)
    else # error has problem, cannot rental a error message here
      set_users
      if @rental.item_type_id.present? && Rental.where(item_type_id: @rental.item_type_id).count == Item.where(item_type_id: @rental.item_type_id).count
        flash[:danger] = "#{ItemType.find(@rental.item_type_id).name} is unavailable for this date."
      else
        flash[:danger] = 'Something went wrong. Please try again.'
      end
      render :new
    end
  end

  # DELETE /rentals/1
  def destroy
    if @rental.may_cancel?
      @rental.cancel!
      flash[:success] = 'Rental canceled.'
    elsif @rental.canceled?
      flash[:warning] = 'This rental is already canceled'
    else
      flash[:warning] = 'This rental may not be canceled'
    end
    redirect_back(fallback_location: rentals_path)
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = Rental.find(params[:id])
  end

  def set_item_types
    @item_types ||= ItemType.all.order(name: :asc)
    @item_types = @item_types.where(name: params['item_type']).order(name: :asc) if params['item_type']
  end

  def set_items
    @items = Item.all
  end

  def set_users
    @users = User.all
  end

  def set_incidental_types
    @incidental_types = IncidentalType.all
  end

  # Only allow a trusted parameter "white list" through.
  def rental_params
    user = User.find(params.require(:rental).permit(:user_id)[:user_id])
    new_time = Time.zone.parse(params[:rental][:end_time]).end_of_day
    params.require(:rental).permit(:start_time, :item_type_id, :user_id).merge(department_id: user.department_id, end_time: new_time)
  end

  def sig_image_params
    params.require(:rental).permit(:customer_signature_image)
  end
end
