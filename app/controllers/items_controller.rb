class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update]

  def index
    @item_types = ItemType.all
    @q = Item.all.search(params[:q])
    @items = @q.result(distinct: true).paginate(page: params[:page], per_page: @per_page)
  end

  def show
  end

  def edit
    @item_types = ItemType.all
  end

  def update
    if @item.update(item_params)
      flash[:success] = 'Item Type Was Successfully Updated'
      redirect_to @item
    else
      @item.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:success] = 'You have deleted the cart'
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
        begin
          Inventory.create_item(itype.uuid, name, true, {})
          flash[:success] = 'Your cart has been successfully created. '
          refresh_items
        rescue
          flash[:danger] = 'Failed to create cart in API'
          redirect_to new_item_items_path
        end
      end
    else
      flash[:danger] = 'Enter a name for the cart'
      redirect_to new_item_items_path
    end
  end

  def refresh_items
    ItemType.all.each do |item_type|
      items = Inventory.items_by_type(item_type.uuid)
      items.each do |item|
        Item.where(name: item['name']).first_or_create(item_type_id: item_type.id, uuid: item['uuid'])
      end
    end
    if flash[:success].nil?
      flash[:success] = 'Items have been updated.'
    else
      flash[:success] << 'Items have been updated.'
    end
    redirect_to items_path
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:name, :item_type_id)
  end
end
