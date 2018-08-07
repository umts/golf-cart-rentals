class ReservationIdIsReallyAString < ActiveRecord::Migration[4.2]
  def change
    change_column(:rentals, :reservation_id, :string)
  end
end
