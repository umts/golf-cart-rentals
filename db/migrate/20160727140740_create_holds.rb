class CreateHolds < ActiveRecord::Migration
  def change
    create_table :holds do |t|
      t.string :hold_reason
      t.datetime :start_time
      t.datetime :end_time
      t.references :item_type
      t.references :item

      t.timestamps null: false
    end
  end
end
