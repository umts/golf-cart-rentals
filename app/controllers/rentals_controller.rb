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

  # GET /rentals/1/edit
  def edit
  end

  # POST /rentals
  def create
    @rental = Rental.new(rental_params)

    if @rental.save
      flash[:success] = 'Rental Was Successfully Created'
      redirect_to @rental
    else
      @rental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end
  # PATCH/PUT /rentals/1
  def update
    if @rental.update(rental_params)
      flash[:success] = 'Rental Was Successfully Updated'
      redirect_to @rental
    else
      @rental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end
  # DELETE /rentals/1
  def destroy
    @rental.destroy
    flash[:success] = 'Rental Was Successfully Deleted'
    redirect_to rentals_url
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rental
      @rental = Rental.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def rental_params
      params.fetch(:rental, {})
    end
end
