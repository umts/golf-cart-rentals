class RemoveAmountFromIncurredIncidentals < ActiveRecord::Migration[5.0]
  def change
    remove_column :incurred_incidentals, :amount
  end
end
