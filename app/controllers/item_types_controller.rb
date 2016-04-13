class ItemTypesController < ApplicationController
  before_action :set_item_type, only: [:show, :edit, :update]

  def index
    @item_types = ItemType.all
  end

  def show
  end

  def edit
  end

  def update
    if @item_type.update(item_type_params)
      flash[:success] = 'Item Type Was Successfully Updated'
      redirect_to @item_type
    else
      @item_type.errors.full_messages.each { |e| flash_message :warning, e, :now }
      render :edit
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_item_type
    @item_type = ItemType.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def item_type_params
    params.require(:item_type).permit(:name, :string, :base_fee, :fee_per_day, :disclaimer)
  end
end
