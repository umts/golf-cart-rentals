class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.string :rental_status
      t.integer :user_id, null: false
      t.integer :department_id, null: false
      t.integer :reservation_id, null: false
      t.integer :fee_schedule_id, null: false
      t.datetime :checked_out_at
      t.datetime :checked_in_at
      t.timestamps null: false
    end
  end
end
