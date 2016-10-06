# frozen_string_literal: true
class HoldsController < ApplicationController
  before_action :set_hold, only: [:show, :edit, :update, :destroy]

  def show
  end

  def index
    @holds = Hold.all
  end

  def new
    @hold = Hold.new
  end

  def create
    @hold = Hold.new(hold_params)

    if @hold.save
      flash[:success] = 'Hold Was Successfully Created'
      redirect_to @hold
    else
      @hold.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def edit
    @item_types = ItemType.where(id: @hold.item_type_id)
  end

  def update
    if @hold.update(hold_params)
      flash[:success] = 'Hold Was Successfully Updated'
      redirect_to @hold
    else
      @hold.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def destroy
    @hold.destroy
    flash[:success] = 'Hold Was Successfully Deleted'
    redirect_to holds_url
  end

  private

  def set_hold
    @hold = Hold.find(params[:id])
  end

  def hold_params
    params.require(:hold).permit(:hold_reason, :start_time, :end_time, :item_id)
  end
end
