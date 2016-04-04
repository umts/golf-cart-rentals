class IncurredIncidentalsController < ApplicationController
  before_action :get_rental_incidental

  def index
    @incidentals = @rental.incurred_incidentals
  end

  def show
  end

  def new
    @incidental = @rental.incurred_incidentals.new
  end

  def create
    @incidental = @rental.incurred_incidentals.create(incidental_params)
  end

  def edit
  end

  def update
    @incidental.update(incidental_params)
  end

  def destroy
    @incidental.destroy
  end

  private

    def get_rental_incidental
      @rental = Rental.find(params[:rental_id])
      @incidental = IncurredIncidental.find(params[:id])
    end

    def incidental_params
      params.require(:incurred_incidental).permit(:times_modified, :notes, :document)
    end

end
