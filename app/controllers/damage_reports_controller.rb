class DamagesController < ApplicationController
  before_action :set_damage, [:show, :edit]

  def show
  end

  def index
    @damage_reports = DamageReport.all
  end

  def new
    @damage_report = DamageReport.new
  end

  def create
    @damage_report = DamageReport.create(damage_params)

    if @damage_report.save

    else

    end
  end

  def edit
  end

  def update
    
  end

  private

  def set_damage
    @damage_report = DamageReport.find(params[:id])
  end

  def damage_params
    require(:damage_report).permit(:type, :location, :repaired_by, :description,
                            :comments, :occurred_on, :repaired_on,
                            :estimated_cost, :actual_cost, :item, :rental)
  end
end
