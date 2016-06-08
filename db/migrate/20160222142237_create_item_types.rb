class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name, null: false
      t.text :disclaimer
      t.float :base_fee
      t.float :fee_per_day

      t.timestamps null: false
    end
  end
end
