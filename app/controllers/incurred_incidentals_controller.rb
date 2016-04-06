# frozen_string_literal: true
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

  def show
    @incidental = IncurredIncidental.find(params[:id])
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
