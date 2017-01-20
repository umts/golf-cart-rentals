class AddDeletedAtToIncurredIncidentals < ActiveRecord::Migration[5.0]
  def change
    add_column :incurred_incidentals, :deleted_at, :datetime
  end
end
