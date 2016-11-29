class DamagesController < ApplicationController
  before_action :set_damage, [:show, :edit]

  def show
  end

  def index
    @damages = Damage.all
  end

  def new
    @damage = Damage.new
  end

  def create
    @damage = Damage.create(damage_params)

    if @damage.save

    else

    end
  end

  def edit
  end

  def update

  end

  private

  def set_damage
    @damage = Damage.find(params[:id])
  end

  def damage_params
    require(:damage).permit(:type, :location, :repaired_by, :description,
                            :comments, :occurred_on, :repaired_on,
                            :estimated_cost, :actual_cost, :item, :rental)
  end
end
