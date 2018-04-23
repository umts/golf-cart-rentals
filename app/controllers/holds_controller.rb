# frozen_string_literal: true
class HoldsController < ApplicationController
  include ApplicationHelper
  before_action :set_hold, only: [:show, :edit, :update, :destroy, :lift]

  after_action :set_return_url, only: %i[index new edit]

  def show; end

  def index
    @holds = Hold.all
  end

  def new
    @hold = Hold.new(new_hold_params)
  end

  def create
    @hold = Hold.new(hold_params.merge(active: true))

    if @hold.save
      flash[:success] = 'Hold Successfully Created'
      @hold.handle_conflicting_rentals

      check_ongoing_conflicts
      redirect_to @hold
    else
      @hold.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :new
    end
  end

  def edit; end

  def update
    if @hold.update(hold_params)
      flash[:success] = 'Hold Successfully Updated'
      @hold.handle_conflicting_rentals

      check_ongoing_conflicts
      redirect_to @hold
    else
      @hold.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def lift
    if @hold.update(active: false) && @hold.lift_hold
      flash[:success] = 'Hold Successfully Resolved'
    else
      @hold.errors.full_messages.each { |e| flash_message :warning, e, :now }
    end
    redirect_to holds_url
  end

  private

  def set_hold
    @hold = Hold.find(params[:id])
  end

  def new_hold_params
    # find_by returns 1 or nil
    { damage: Damage.find_by(id: params.fetch(:damage_id, nil)), item_id: params.fetch(:item_id, nil) }
  end

  def hold_params
    item_type_id = Item.find(params[:hold][:item_id]).item_type_id

    # will evaluate to nil or an instance of damage
    damage = Damage.find_by id: params.fetch(:damage_id, nil)
    params.require(:hold).permit(:hold_reason, :item_id,
                                 :start_time, :end_time).merge(item_type_id: item_type_id, damage: damage)
  end

  def check_ongoing_conflicts
    # rental that has already started and conflicts with hold,
    # needs to be handled by a csr
    if rental = @hold.conflicting_ongoing_rental
      flash[:warning] = "Ongoing #{view_context.link_to 'rental', rental} with item"
    end
  end
end
