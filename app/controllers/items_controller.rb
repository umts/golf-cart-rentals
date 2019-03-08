# frozen_string_literal: true
class ItemsController < ApplicationController
  before_action :set_item, only: %i[show edit update destroy]

  def index
    @item_types = ItemType.all
    @q = Item.ransack(params[:q])
    @items = @q.result.paginate(page: params[:page], per_page: 8)
  end

  def show; end

  def edit
    @item_types = ItemType.all
  end

  def update
    if @item.update(item_params)
      flash[:success] = 'Item successfully Updated'
      redirect_to @item
    else
      flash[:danger] = @item.errors.full_messages
      render :edit
    end
  end

  def destroy
    @item.destroy
    flash[:success] = 'Item successfully Deleted'
    redirect_to items_path
  end

  def new_item
    @item_types = ItemType.all
  end

  def create_item
    name = params[:name]
    type = params[:type]
    if name.present?
      ItemType.where(name: type).each do |itype|
        create_item_helper(itype.uuid, name)
      end
    else
      flash[:danger] = 'Name is a required field'
      redirect_to new_items_path
    end
  end

  def refresh_items
    begin
      ItemType.all.each do |item_type|
        refresh_items_helper(item_type)
      end

      flash[:success] ||= 'Items successfully Updated'
    rescue => error
      flash[:danger] = "Failed to refresh Items from Inventory API: #{error.inspect}"
    end
    redirect_to items_path
  end

  private

  def create_item_helper(uuid, name)
    Inventory.create_item(uuid, name, true, {})
    flash[:success] = 'Cart Successfully Created'
    refresh_items
  rescue => error
    flash[:danger] = "Failed to create Item in Inventory API: #{error.inspect}"
    redirect_to new_items_path
  end

  def refresh_items_helper(item_type)
    items = Inventory.items_by_type(item_type.uuid)
    items.each do |item|
      Item.where(name: item['name']).first_or_create(item_type_id: item_type.id, uuid: item['uuid'])
    end
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :item_type_id)
  end
end
