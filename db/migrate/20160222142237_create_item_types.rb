class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name
      t.references :fee_schedule

      t.timestamps null: false
    end
  end
end
