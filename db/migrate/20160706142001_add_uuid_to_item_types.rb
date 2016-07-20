class AddUuidToItemTypes < ActiveRecord::Migration
  def change
    add_column(:item_types, :uuid, :string, null: false)
    add_index(:item_types, :uuid, unique: true)
  end
end
