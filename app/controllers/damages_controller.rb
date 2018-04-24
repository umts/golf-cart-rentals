# frozen_string_literal: true
class DamagesController < ApplicationController
  before_action :find_damage, only: [:show, :edit, :update]

  def show; end

  def index
    @damages = Damage.all
  end

  def new
    @damage = Damage.new(new_params)
    flash[:danger] = 'Damage Created Without An Attached Incurred Incidental' unless @damage.incurred_incidental
  end

  def create
    @damage = Damage.create(damage_params)

    if @damage.save
      flash[:success] = 'Damage Successfully Created'
      redirect_to @damage
    else
      flash[:warning] = 'Failed To Create Damage'
      render 'new'
    end
  end

  def edit; end

  def update
    if @damage.update(damage_params)
      flash[:success] = 'Damage Successfully Updated'
      redirect_to @damage
    else
      flash[:warning] = 'Failed To Update Damage'
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
