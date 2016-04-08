class IncurredIncidentalsController < ApplicationController
  # Set auto papertrail
  before_action :set_paper_trail_whodunnit

  before_action :get_rental
  before_action :get_incidental, only: [:show, :edit, :update, :deactivate]

  def index
    @incidentals = @rental.incurred_incidentals
  end

  def show
  end

  def new
    @incidental = @rental.incurred_incidentals.new
  end

  def create
    @incidental = @rental.incurred_incidentals.new(incidental_params)
    respond_to do |format|
      if @incidental.save
        format.html { redirect_to rental_incurred_incidental_path(@rental, @incidental),
                      notice: 'Incidental successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @incidental.update(incidental_params)
        format.html { redirect_to rental_incurred_incidental_path(@rental, @incidental),
                      notice: 'Incidental successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  #def destroy
  #  @incidental.destroy
  #  respond_to do |format|
  #    format.html { redirect_to rental_incurred_incidentals_path,
  #                  notice: 'Incidental successfully destroyed.' }
  #  end
  #end
  def change_active
    respond_to do |format|
      if @incidental.update(is_active: @incidental.re_de_activate)
        format.html { redirect_to rental_incurred_incidentals_path,
                      notice: 'Incidental successfully updated.' }
      else
        format.html { render :index, notice: 'Failed to update incidental' }
      end
    end
  end

  private

    def get_rental
      @rental = Rental.find(params[:rental_id])
    end

    def get_incidental
      @incidental = IncurredIncidental.find(params[:id])
    end

    def incidental_params
      params.require(:incurred_incidental).permit(:incidental_type_id, :times_modified, :notes, :document, :is_active)
    end

end
