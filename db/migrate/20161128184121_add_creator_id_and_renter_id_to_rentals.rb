class AddCreatorIdAndRenterIdToRentals < ActiveRecord::Migration[5.0]
  def change
    add_column :rentals, :creator_id, :integer
    add_column :rentals, :renter_id, :integer
    remove_column :rentals, :user_id, :integer # no longer needed
  end
end
