class IncurredIncidentalsController < ApplicationController
  before_action :get_rental

  def index
    @incidentals = @rental.incurred_incidentals
  end

  def show
    @incidental = IncurredIncidental.find(params[:id])
  end

  def new
    @incidental = @rental.incurred_incidentals.new
  end

  def create
    @incidental = @rental.incurred_incidentals.new(incidental_params)
    respond_to do |format|
      if @incidental.save
        format.html { redirect_to rental_incurred_incidental_path(@rental, @incidental), notice: 'Incidental successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
    @incidental = IncurredIncidental.find(params[:id])
  end

  def update
    @incidental = IncurredIncidental.find(params[:id])

    respond_to do |format|
      if @incidental.update(incidental_params)
        format.html { redirect_to rental_incurred_incidental_path(@rental, @incidental), notice: 'Incidental successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @incidental.destroy
  end

  private

    def get_rental
      @rental = Rental.find(params[:rental_id])
    end

    def incidental_params
      params.require(:incurred_incidental).permit(:times_modified, :notes, :document)
    end

end
