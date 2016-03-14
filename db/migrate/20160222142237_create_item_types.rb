class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name, null: false
      t.text :disclaimer
      t.references :fee_schedule

      t.timestamps null: false
    end

    add_index :item_types, :fee_schedule_id
  end
end
