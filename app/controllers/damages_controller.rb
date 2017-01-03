class DamagesController < ApplicationController
  before_action :set_damage, only: [:show, :edit]

  def show
  end

  def index
    @damages = Damage.all
  end

  def new
    @damage = Damage.new
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

    def damage_params
      require(:damage).permit(:location, :repaired_by, :description,
                              :occurred_on, :repaired_on, :estimated_cost, :actual_cost)
    end
end
