class HoldsController < ApplicationController
  before_action :set_hold, only: [:show, :edit, :update, :destroy, :lift]

  def show
  end

  def index
    @holds = Hold.all
  end

  def new
    @hold = Hold.new
  end

  def create
    @hold = Hold.new(hold_params.merge(active?: true))

    if @hold.save
      flash[:success] = 'Hold Successfully Created'
      redirect_to @hold
    else
      flash[:warning] = 'Error creating Hold: '
      flash_errors
      render :new
    end
  end

  def edit
  end

  def update
    if @hold.update(hold_params)
      flash[:success] = 'Hold Successfully Updated'
      redirect_to @hold
    else
      flash[:warning] = 'Error updating Hold: '
      flash_errors
      render :edit
    end
  end

  def lift
    if @hold.lift_hold
      flash[:success] = 'Hold Successfully Resolved'
    else
      flash[:warning] = 'Error lifting Hold: '
      flash_errors
    end
    redirect_to holds_url
  end

  private

  def set_hold
    @hold = Hold.find(params[:id])
  end

  def hold_params
    item_type_id = Item.find(params[:hold][:item_id]).item_type_id
    params.require(:hold).permit(:hold_reason, :item_id, :start_time, :end_time).merge(item_type_id: item_type_id)
  end

  def flash_errors
    @hold.errors.full_messages.each { |e| flash_message :warning, e, :now }
  end
end
