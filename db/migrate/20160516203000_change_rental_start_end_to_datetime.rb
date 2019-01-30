class ChangeRentalStartEndToDatetime < ActiveRecord::Migration[4.2]
  def change
    remove_column :rentals, :start_date
    add_column :rentals, :start_time, :datetime
    remove_column :rentals, :end_date
    add_column :rentals, :end_time, :datetime
  end
end
