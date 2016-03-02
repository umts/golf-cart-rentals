class FeeSchedulesController < ApplicationController
  before_action :set_fee_schedule, only: [:show, :edit, :update, :destroy]

  # GET /fee_schedules
  # GET /fee_schedules.json
  def index
    @fee_schedules = FeeSchedule.all
  end

  # GET /fee_schedules/1
  # GET /fee_schedules/1.json
  def show
  end

  # GET /fee_schedules/new
  def new
    @fee_schedule = FeeSchedule.new
  end

  # GET /fee_schedules/1/edit
  def edit
  end

  # POST /fee_schedules
  # POST /fee_schedules.json
  def create
    @fee_schedule = FeeSchedule.new(fee_schedule_params)

    respond_to do |format|
      if @fee_schedule.save
        format.html { redirect_to @fee_schedule, notice: 'Fee schedule was successfully created.' }
        format.json { render :show, status: :created, location: @fee_schedule }
      else
        format.html { render :new }
        format.json { render json: @fee_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /fee_schedules/1
  # PATCH/PUT /fee_schedules/1.json
  def update
    respond_to do |format|
      if @fee_schedule.update(fee_schedule_params)
        format.html { redirect_to @fee_schedule, notice: 'Fee schedule was successfully updated.' }
        format.json { render :show, status: :ok, location: @fee_schedule }
      else
        format.html { render :edit }
        format.json { render json: @fee_schedule.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /fee_schedules/1
  # DELETE /fee_schedules/1.json
  def destroy
    @fee_schedule.destroy
    respond_to do |format|
      format.html { redirect_to fee_schedules_url, notice: 'Fee schedule was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_fee_schedule
    @fee_schedule = FeeSchedule.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def fee_schedule_params
    params.require(:fee_schedule).permit(:base_amount, :amount_per_day)
  end
end
