class FeeSchedulesController < ApplicationController
  before_action :set_fee_schedule, only: [:show, :edit, :update, :destroy]
  before_action :get_item_types, only: [:index, :new, :create, :edit, :update]

  def index
    @fee_schedules = FeeSchedule.all
  end

  def show
  end

  def new
    @fee_schedule = FeeSchedule.new
  end

  def edit
  end

  def create
    @fee_schedule = FeeSchedule.new(fee_schedule_params)

    if @fee_schedule.save
      flash[:success] = 'Fee Schedule Was Successfully Created'
      redirect_to @fee_schedule
    else
      @fee_schedule.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def update
    if @fee_schedule.update(fee_schedule_params)
      flash[:success] = 'Fee Schedule Was Successfully Updated'
      redirect_to @fee_schedule
    else
      @fee_schedule.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def destroy
    @fee_schedule.destroy
    flash[:success] = 'Fee Schedule Was Successfully Deleted'
    redirect_to fee_schedules_url
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fee_schedule
    @fee_schedule = FeeSchedule.find(params[:id])
  end

  def get_item_types
    @item_types = ItemType.all
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def fee_schedule_params
    params.require(:fee_schedule).permit(:base_amount, :amount_per_day, :item_type_id)
  end
end
