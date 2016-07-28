class AddItemRefToRental < ActiveRecord::Migration
  def change
    add_reference(:rentals, :item, null: false)
  end
end
