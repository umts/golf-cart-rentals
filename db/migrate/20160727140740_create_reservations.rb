class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :type
      t.integer :reservation_id
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps null: false
    end
  end
end
