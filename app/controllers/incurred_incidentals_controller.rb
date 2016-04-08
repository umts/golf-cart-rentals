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
