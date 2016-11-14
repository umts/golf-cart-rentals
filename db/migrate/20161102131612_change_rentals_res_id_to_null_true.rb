class ChangeRentalsResIdToNullTrue < ActiveRecord::Migration[5.0]
  def change
    change_column_null(:rentals, :reservation_id, true)
  end
end
