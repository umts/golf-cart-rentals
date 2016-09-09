# frozen_string_literal: true
class IncurredIncidentalsController < ApplicationController
  before_action :set_incurred_incidental, only: [:edit, :update, :destroy, :show]
  before_action :set_incidental_types, only: [:new, :edit, :create, :update]
  before_action :set_rentals, only: [:new, :edit, :create, :update]

  def show
    @incurred_incidental = IncurredIncidental.find(params[:id])
  end

  def index
    @incurred_incidentals = IncurredIncidental.all
  end

  def new
    @incurred_incidental = IncurredIncidental.new
  end

  def create
    @incurred_incidental = IncurredIncidental.new(incidental_params)
    # @incurred_incidental.notes << Note.create(note: params[:incurred_incidental][:note][:note])
    respond_to do |format|
      if @incurred_incidental.save
        format.html { redirect_to incurred_incidental_path(@incurred_incidental),
                      flash: { success: 'Incidental successfully created' } }
      else
        format.html { render :new,
                      flash: { error: 'Failed to update Incidental' } }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      # @incurred_incidental.notes << Note.create(note: params[:incurred_incidental][:note][:note])
      if @incurred_incidental.update(incidental_params)
        format.html { redirect_to incurred_incidental_path(@incurred_incidental),
                      flash: { success: 'Incidental successfully updated' } }
      else
        format.html { render :edit,
                      flash: { error: 'Failed to update Incidental' } }
      end
    end
  end

  def destroy
    @incurred_incidental.destroy
    respond_to do |format|
      format.html { redirect_to incurred_incidentals_path,
                    flash: { success: 'Incidental successfully deleted' } }
    end
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

    def incidental_params
      params.require(:incurred_incidental).permit(:rental_id, :incidental_type_id, :times_modified)
    end
end
