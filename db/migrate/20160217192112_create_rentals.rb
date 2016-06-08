class CreateRentals < ActiveRecord::Migration
  def change
    create_table :rentals do |t|
      t.string :rental_status, null: false
      t.integer :user_id, null: false
      t.integer :department_id
      t.integer :reservation_id, null: false
      t.references :item_type, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.datetime :checked_in_at
      t.datetime :checked_out_at
      t.datetime :checked_in_at
      t.timestamps null: false
    end

    add_index :rentals, :item_type_id
    add_index :rentals, :rental_status
  end
end
