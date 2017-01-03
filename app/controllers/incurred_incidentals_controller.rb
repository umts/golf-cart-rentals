# frozen_string_literal: true
class IncurredIncidentalsController < ApplicationController
  before_action :set_incurred_incidental, only: [:edit, :update, :show]
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
    @rental = Rental.find(params[:rental_id])
  end

  def create
    @incurred_incidental = IncurredIncidental.new(incidental_params)
    if @incurred_incidental.save
      flash[:success] = 'Incidental successfully created'
      if @incurred_incidental.incidental_type.damage_tracked 
        flash[:notice] = 'Please Create Associated Damage Tracking'
        redirect_to new_damage_path(incurred_incidental: @incurred_incidental)
      else
        redirect_to incurred_incidental_path(@incurred_incidental)
      end
    else
      render :new
      flash[:error] = 'Failed to update Incidental'
    end
  end

  def edit
    @rental = @incurred_incidental.rental
  end

  def update
    respond_to do |format|
      if @incurred_incidental.update(incidental_params)
        format.html do
          redirect_to incurred_incidental_path(@incurred_incidental)
          flash[:success] = 'Incidental successfully updated'
        end
      else
        format.html do
          render :edit
          flash[:error] = 'Failed to update Incidental'
        end
      end
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
    params.require(:incurred_incidental).permit(:rental_id, :incidental_type_id, :amount, notes_attributes: [:note])
  end
end
