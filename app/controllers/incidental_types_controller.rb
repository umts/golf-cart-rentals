# frozen_string_literal: true
class IncidentalTypesController < ApplicationController
  before_action :set_incidental_type, only: [:edit, :update, :destroy, :show]
  before_action :set_rentals, only: [:new, :edit, :create, :update]

  after_action :set_return_url, only: [:index]

  def show; end

  def index
    @incidental_types = IncidentalType.all
  end

  def new
    @incidental_type = IncidentalType.new
  end

  def create
    @incidental_type = IncidentalType.new(incidental_type_params)
    if @incidental_type.save
      flash[:success] = 'Incidental Type successfully created'
      redirect_to @incidental_type
    else
      flash[:danger] = @incidental_type.errors.full_messages
      render :new
    end
  end

  def edit; end

  def update
    if @incidental_type.update(incidental_type_params)
      flash[:success] = 'Incidental Type successfully updated'
      redirect_to @incidental_type
    else
      flash[:danger] = @incidental_type.errors.full_messages
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
