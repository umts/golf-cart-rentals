class ReservationIdIsReallyAString < ActiveRecord::Migration
  def change
    change_column(:rentals, :reservation_id, :string)
  end
end
