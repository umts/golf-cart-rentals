# frozen_string_literal: true
class RentalsController < ApplicationController
  @per_page = 10

  before_action :set_rental, only: [:show, :edit, :update, :destroy, :transform, :invoice]
  before_action :set_item_types, only: [:index, :new, :create, :edit, :update, :processing]
  before_action :set_items, only: [:index, :new, :create, :edit, :update, :processing]
  before_action :set_users, only: [:index, :new, :processing, :transform]
  before_action :set_incidental_types, only: [:new]
  before_action :set_financial_transactions, only: [:show, :invoice]

  # GET /rentals
  def index
    @q = Rental.all.search(params[:q])
    @rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
    @users = User.all

    gon.reservations = Rental.to_json_reservations
  end

  # GET /rentals/1
  def show
  end

  # GET /rentals/cost?end_time=time&start_time=time&item_type=1
  def cost
    start_time = params[:start_time]
    end_time = params[:end_time]
    item_type = ItemType.find(params[:item_type]) if params[:item_type]
    render json: Rental.rental_cost(start_time, end_time, item_type)
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
      render :pickup, locals: { rental: @rental }
    elsif @rental.picked_up?
      render :drop_off, locals: { rental: @rental }
    else
      flash[:danger] = 'Error redirecting to processing form'
      render :index
    end
  end

  # PUT /rentals/1/
  def update
    if params[:commit] == 'Pick Up'
      DigitalSignature.create(image: sig_image_params, intent: :pickup, rental: @rental, author: :customer)
      if @rental.pickup
        pickup_name = params[:rental][:pickup_name]
        pickup_number = params[:rental][:pickup_phone_number]
        @rental.update(pickup_name: pickup_name, pickup_phone_number: pickup_number)
      end
    elsif params[:commit] == 'Drop Off'
      DigitalSignature.create(image: sig_image_params, intent: :drop_off, rental: @rental, author: :customer)
      if @rental.drop_off
        dropoff_name = params[:rental][:dropoff_name]
        dropoff_number = params[:rental][:dropoff_phone_number]
        @rental.update(dropoff_name: dropoff_name, dropoff_phone_number: dropoff_number)
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
    @rental = Rental.new(rental_params)

    @start_date = rental_params['start_date'] || Time.zone.today

    if @rental.save
      if params[:amount] && @current_user.has_permission?('rentals', 'cost_adjustment')
        FinancialTransaction.create rental: @rental.id, amount: params[:amount], transactable_type: Rental.class, transactable_id: @rental.id
      end # if they dont have permission ignore it and we will use default pricing

      flash[:success] = 'You have succesfully reserved your Rental!'
      redirect_to(@rental)
    else # error has problem, cannot rental a error message here
      @rental.errors.full_messages.each { |e| flash_message :warning, e, :now }
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

  # GET /rentals/1/invoice
  def invoice
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = Rental.find(params[:id])
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
    params.require(:rental).permit(:start_time, :item_type_id, :user_id, :pickup_name, :dropoff_name,
                                   :pickup_phone_number, :dropoff_phone_number).merge(department_id: user.department_id, end_time: new_time)
  end

  def sig_image_params
    params.require(:rental).permit(:customer_signature_image)
  end
end
