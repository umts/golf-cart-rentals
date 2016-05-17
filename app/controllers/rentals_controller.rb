class RentalsController < ApplicationController
  @per_page = 10

  before_action :set_rental, only: [:show, :edit, :update, :destroy]
  before_action :set_item_types, only: [:index, :new, :create, :edit, :update, :processing]

  # GET /rentals
  def index
    @q = Rental.all.search(params[:q])
    @rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
    @users = User.all
  end
  
  # GET /rentals/processing
  def processing
    @q = Rental.all.search(params[:q])
    @rentals = @q.result(distinct: true).where('start_time >= ? AND start_time <= ?', Time.current.beginning_of_day, Time.current.end_of_day).paginate(page: params[:page], per_page: @per_page)
    @users = User.all
  end

  # PUT /rentals/1/
  def update
    @rental.update rental_params
  end

  # GET /rentals/1
  def show
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
  end

  # POST /rentals
  def create
    if params[:disclaimer] != '1'
      flash[:success] = 'You must agree to the terms and conditions before creating a rental'
      render(:new) && return
    end

    rental = Rental.new(rental_params)
    if rental.save
      flash[:success] = 'Rental Was Successfully Created'
      redirect_to(rental)
    else
      rental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  # DELETE /rentals/1
  def destroy
    @rental.destroy
    flash[:success] = 'Rental Was Successfully Deleted'
    redirect_to :back
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = Rental.find(params[:id])
  end

  def set_item_types
    @item_types = ItemType.all
  end

  # Only allow a trusted parameter "white list" through.
  def rental_params
    p = params.require(:rental).permit(:start_time, :end_time, :item_type_id).merge(user_id: @current_user.id, department: @current_user.department)
    p[:start_time] = p[:start_time].to_datetime if p[:start_time]
    p[:end_time] = p[:end_time].to_datetime if p[:end_time]
    p
  end
end
