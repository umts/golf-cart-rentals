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
    @incidental.notes << Note.create(note: params[:incurred_incidental][:note][:note])
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
      @incidental.notes << Note.create(note: params[:incurred_incidental][:note][:note])
      if @incidental.update(incidental_params)
        format.html { redirect_to rental_incurred_incidental_path(@rental, @incidental),
                      notice: 'Incidental successfully updated.' }
      else
        format.html { render :edit }
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
      # :notes, :document
      params.require(:incurred_incidental).permit(:incidental_type_id, :times_modified, :is_active)
    end

end
