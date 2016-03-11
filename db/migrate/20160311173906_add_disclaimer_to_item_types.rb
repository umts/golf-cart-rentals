class AddDisclaimerToItemTypes < ActiveRecord::Migration
  def change
    add_column :item_types, :disclaimer, :text
  end
end
