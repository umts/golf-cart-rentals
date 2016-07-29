class ReservationsController < ApplicationController
  before_action :set_reservation, only: [:new, :edit, :update, :create, :destroy]
  before_action :set_item_types

  def index
    @reservations = Reservation.all
  end

  def new
    @reservation = Reservation.new
  end

  def show
  end

  def edit
  end

  def update
    if @reservation.update(reservation_params)
      flash[:success] = 'Reservation Was Successfully Updated'
      redirect_to @reservation
    else
      @reservation.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def create
    @reservation = Reservation.new(reservation_params)
    @reservation.create_reservation(params[:end_time])

    if @reservation.save
      flash[:success] = 'Reservation Was Successfully Created'
      redirect_to @reservation
    else
      @reservation.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def destroy
    begin
      delete_reservation(@reservation.reservation_id)
      @reservation.destroy
      flash[:success] = 'Reservation Was Successfully Deleted'
      redirect_to reservations_url
    rescue
      errors.add :base, error.inspect
      render @reservation
    end
  end

  private

  def set_reservation
    @reservation = Reservation.find(params[:id])
  end

  def reservation_params
    params.require(:reservation).permit(:type, :item_type)
  end
end
