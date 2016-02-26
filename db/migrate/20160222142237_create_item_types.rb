class CreateItemTypes < ActiveRecord::Migration
  def change
    create_table :item_types do |t|
      t.string :name
      t.references :fee_schedule

      t.timestamps null: false
    end
<<<<<<< a5606bdf467f4390bd723053952bde070d2121d0

    add_index :item_types, :fee_schedule_id
=======
>>>>>>> edit the merge conflict
  end
end
