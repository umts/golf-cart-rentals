class AddItemRefToRental < ActiveRecord::Migration[4.2]
  def change
    add_reference(:rentals, :item, null: false)
  end
end
