class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :reservation_type
      t.string :reservation_id
      t.datetime :start_time
      t.datetime :end_time
      t.references :item_type
      t.references :item

      t.timestamps null: false
    end
  end
end
