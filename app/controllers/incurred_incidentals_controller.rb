class IncurredIncidentalsController < ApplicationController
  before_action :set_incurred_incidental, only: [:edit, :update, :destroy, :show]
  before_action :set_incidental_types, only: [:new, :edit, :create, :update]
  before_action :set_rentals, only: [:new, :edit, :create, :update]

  def index
    @incurred_incidentals = IncurredIncidental.all
  end

  def new
    @incurred_incidental = IncurredIncidental.new
  end

  def edit
    params[:rental_id] = @incurred_incidental.rental.id
    params[:incidental_type_id] = @incurred_incidental.incidental_type.id
  end

  def show
  end

  def create
    @incurred_incidental = IncurredIncidental.new(incurred_incidental_params)

    if @incurred_incidental.save
      flash[:success] = 'New Incurred Incidental Was Successfully Created'
      redirect_to @incurred_incidental
    else
      @incurred_incidental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def update
    if @incurred_incidental.update(incurred_incidental_params)
      flash[:success] = 'Incurred Incidental Was Successfully Updated'
      redirect_to @incurred_incidental
    else
      @incurred_incidental.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def destroy
    @incurred_incidental.destroy
    flash[:success] = 'Incurred Incidental Was Successfully Deleted'
    redirect_to incurred_incidental_url
  end

  private

  def set_incurred_incidental
    @incurred_incidental = IncurredIncidental.find(params[:id])
  end

  def set_incidental_types
    @incidental_types = IncidentalType.all
  end

  def set_rentals
    @rentals = Rental.all
  end

  def incurred_incidental_params
    params.require(:incurred_incidental).permit(:incidental_type_id, :rental_id, :times_modified)
  end
end
