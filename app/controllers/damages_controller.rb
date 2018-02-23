# frozen_string_literal: true
class DamagesController < ApplicationController
  before_action :find_damage, only: [:show, :edit, :update]

  after_action :set_return_url, only: [:index]

  def show; end

  def index
    @damages = Damage.all
  end

  def new
    @damage = Damage.new(new_params)
    unless @damage.incurred_incidental
      flash[:danger] = 'Damage created without an attached Incurred Incidental'
    end
  end

  def create
    @damage = Damage.create(damage_params)

    if @damage.save
      flash[:success] = 'Damage successfully Created'
      redirect_to @damage
    else
      flash[:warning] = 'Failed to create Damage'
      @damage.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render 'new'
    end
  end

  def edit; end

  def update
    if @damage.update(damage_params)
      flash[:success] = 'Damage successfully Updated'
      redirect_to @damage
    else
      flash[:warning] = 'Failed to update Damage'
      @damage.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render 'edit'
    end
  end

  private

  def find_damage
    @damage = Damage.find(params[:id])
  end

  def new_params
    params.permit(:incurred_incidental_id)
  end

  def damage_params
    params.require(:damage).permit(:location, :repaired_by, :description, :incurred_incidental_id,
                                   :occurred_on, :repaired_on, :estimated_cost, :actual_cost)
  end
end
