# frozen_string_literal: true
class ItemTypesController < ApplicationController
  before_action :set_item_type, only: [:show, :edit, :update]

  def index
    @item_types = ItemType.all
  end

  def show; end

  def edit; end

  def update
    if @item_type.update(item_type_params)
      flash[:success] = 'Item Type Successfully Updated'
      redirect_to @item_type
    else
      @item_type.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def new_item_type
    @item_types = ItemType.all
  end

  def create_item_type
    name = params[:name]
    base_fee = params[:base_fee]
    fee_per_day = params[:fee_per_day]
    if name.present?
      create_item_type_helper(name, base_fee, fee_per_day) # protect better
    else
      flash[:danger] = 'Invalid Item Type' # better errors
      redirect_to new_item_types_path
    end
  end

  def refresh_item_types(base_fee = 0, fee_per_day = 0)
    inv_item_types = Inventory.item_types.each_with_object({}) do |i, memo|
      memo[ i['name'] ] = i['uuid']
    end
    inv_item_types.each do |inv_item_type|
      item_types = ItemType.all.each_with_object({}) do |i, memo|
        memo[i[:name]] = i[:uuid]
      end

      unless item_types.keys.include?(inv_item_type[0])
        begin
          ItemType.where(name: inv_item_type[0], uuid: inv_item_type[1], base_fee: base_fee, fee_per_day: fee_per_day).first_or_create
          flash[:success] ||= 'Item Types Successfully Updated'
        rescue => error
          flash[:danger] = "Failed to Refresh Item Types From API. #{error.inspect}"
        end
      end
    end
    redirect_to item_types_path
  end

  private

  def create_item_type_helper(name)
    Inventory.create_item_type(name)
    flash[:success] = 'Item Type Successfully Created'
    refresh_item_types
  rescue => error
    flash[:danger] = "Failed To Create Item Type In API. #{error.inspect}"
    redirect_to new_item_types_path
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_item_type
    @item_type = ItemType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_type_params
    params.require(:item_type).permit(:name, :string, :base_fee, :fee_per_day)
  end
end
