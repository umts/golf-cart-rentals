class RentalsController < ApplicationController
  before_action :set_rental, only: [:show, :edit, :update, :destroy]

  # GET /rentals
  def index
    @rentals = Rental.all
  end

  # GET /rentals/1
  def show
  end

  # GET /rentals/new
  def new
    @rental = Rental.new
    @item_types = ItemType.all
  end

  # POST /rentals
  def create
    if params[:disclaimer] != '1'
      flash[:success] = 'You must agree to the terms and conditions before creating a rental'
      render(:new) && return
    end

    @rental = Rental.new(rental_params)

    if @rental.create_reservation
      flash[:success] = 'Rental Was Successfully Created'
      redirect_to(@rental)
    else
      @rental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      @item_types = ItemType.all
      render :new
    end
  end

  # DELETE /rentals/1
  def destroy
    # call aggressive-epsilon API to delete reservation
    # if successful, delete the rental object and redirect to it
    # if unsuccessful, render an error and rerender the show page
    # @rental = @rental.destroy_rental

    # @rental.destroy
    # flash[:success] = 'Rental Was Successfully Deleted'
    # redirect_to rentals_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = Rental.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def rental_params
    p = params.require(:rental).permit(:start_date, :end_date, :item_type_id).merge(user_id: @current_user.id, department_id: @current_user.department_id)
    p[:start_date] = p[:start_date].to_datetime if p[:start_date]
    p[:end_date] = p[:end_date].to_datetime if p[:end_date]
    p
  end
end
