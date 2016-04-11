class RentalsController < ApplicationController
<<<<<<< HEAD
  before_action :set_rental, only: [:show, :edit, :update, :destroy]
  after_create :create_financial_transaction

  def index
    @rentals = Rental.all
  end

  def show
  end

=======
  @@per_page = 10

  before_action :set_rental, only: [:show, :edit, :update, :destroy]
  before_action :get_item_types, only: [:index, :new, :create, :edit, :update]

  # GET /rentals
  def index
    @q = Rental.all.search(params[:q])
    @rentals = @q.result(distinct: true).paginate(page: params[:page], per_page: @@per_page)
    @users = User.all
  end

  # GET /rentals/1
  def show
  end

  # GET /rentals/new
>>>>>>> bffca3d21e8ccb401896c14ad4e397b152895acb
  def new
    @rental = Rental.new
  end

<<<<<<< HEAD
  def edit
  end

  def create
    @rental = Rental.new(rental_params)

    if @rental.save
      flash[:success] = 'Rental Was Successfully Created'
      redirect_to @rental
=======
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
>>>>>>> bffca3d21e8ccb401896c14ad4e397b152895acb
    else
      @rental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

<<<<<<< HEAD
  def update
    if @rental.update(rental_params)
      flash[:success] = 'Rental Was Successfully Updated'
      redirect_to @rental
    else
      @rental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

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

    def create_financial_transaction
      # Set values are tentative and subjected to future changes based on spec

      # Created Upon Rental Creation
      fee = FeeSchedule.first.id
      FinancialTransaction.create rental_id: Rental.last.id,
                                  transactable_id: fee,
                                  transactable_type: FeeSchedule.name,
                                  amount: fee.base_amount,
                                  adjustment: 0

       # Created Upon Rental Checkin

       # Created Upon Rental Adjustments or possible Coupons
    end



=======
  # DELETE /rentals/1
  def destroy
    if @rental.delete_reservation
      @rental.destroy
      flash[:success] = 'Rental Was Successfully Deleted'
      redirect_to :back
    else
      @rental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      redirect_to :back
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_rental
    @rental = Rental.find(params[:id])
  end

  def get_item_types
    @item_types = ItemType.all
  end

  # Only allow a trusted parameter "white list" through.
  def rental_params
    p = params.require(:rental).permit(:start_date, :end_date, :item_type_id).merge(user_id: @current_user.id, department_id: @current_user.department_id)
    p[:start_date] = p[:start_date].to_datetime if p[:start_date]
    p[:end_date] = p[:end_date].to_datetime if p[:end_date]
    p
  end
>>>>>>> bffca3d21e8ccb401896c14ad4e397b152895acb
end
