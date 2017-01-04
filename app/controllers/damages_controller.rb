class DamagesController < ApplicationController
  before_action :set_damage, only: [:show, :edit]

  def show
  end

  def index
    @damages = Damage.all
  end

  def new
    @damage = Damage.new(new_params)
    if !@damage.incurred_incidental
      flash[:danger] = 'You Are Creating A Damage Without An Attached Incurred Incidental'
    end
  end

  def create
    binding.pry
    @damage = Damage.create(damage_params)

    if @damage.save
      flash[:success] = 'Damage successfully created'
      redirect_to @damage
    else
      flash[:warning] = 'Error creating Damage'
      render 'new'
    end
  end

  def edit
  end

  def update
    if @damage.update(damage_params)
      flash[:success] = 'Damage successfully updated'
      redirect_to @damage
    else
      flash[:warning] = 'Error updating Damage'
      render 'edit'
    end
  end

  private

    def set_damage
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
