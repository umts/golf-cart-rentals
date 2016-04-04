class AddRentalIdToIncurredIncidental < ActiveRecord::Migration
  def change
    add_reference :incurred_incidentals, :rental, index: true, foreign_key: true
  end
end
