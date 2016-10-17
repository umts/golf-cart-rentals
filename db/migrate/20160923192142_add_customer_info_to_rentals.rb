class AddCustomerInfoToRentals < ActiveRecord::Migration[5.0]
  def change
    add_column :rentals, :pickup_name, :string
    add_column :rentals, :dropoff_name, :string
    add_column :rentals, :pickup_phone_number, :string
    add_column :rentals, :dropoff_phone_number, :string
  end
end
