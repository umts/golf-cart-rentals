# frozen_string_literal: true
class IncidentalTypesController < ApplicationController
  before_action :set_incidental_type, only: [:edit, :update, :destroy, :show]
  before_action :set_rentals, only: [:new, :edit, :create, :update]

  after_action :set_return_url, only: [:index, :new, :edit]

  def index
    @incidental_types = IncidentalType.all
  end

  def new
    @incidental_type = IncidentalType.new
  end

  def edit; end

  def show; end

  def create
    @incidental_type = IncidentalType.new(incidental_type_params)
    if @incidental_type.save
      flash[:success] = 'Incidental Type Successfully Created'
      redirect_to @incidental_type
    else
      @incidental_type.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def update
    if @incidental_type.update(incidental_type_params)
      flash[:success] = 'Incidental Type Successfully Updated'
      redirect_to @incidental_type
    else
      @incidental_type.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def destroy
    @incidental_type.destroy
    flash[:success] = 'Incidental Type Successfully Deleted'
    redirect_to incidental_types_url
  end

  private

  def set_incidental_type
    @incidental_type = IncidentalType.find(params[:id])
  end

  def set_rentals
    @rentals = Rental.all
  end

  def incidental_type_params
    params.require(:incidental_type).permit(:name, :description, :base, :damage_tracked)
  end
end
