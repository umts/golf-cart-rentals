class DropDisclaimerFromItemType < ActiveRecord::Migration[5.0]
  def change
    remove_column :item_types, :disclaimer
  end
end
