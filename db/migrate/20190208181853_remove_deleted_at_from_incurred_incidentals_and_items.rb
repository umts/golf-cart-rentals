class RemoveDeletedAtFromIncurredIncidentalsAndItems < ActiveRecord::Migration[5.2]
  def change
    remove_column :incurred_incidentals, :deleted_at, :datetime
    remove_column :items, :deleted_at, :datetime
  end
end
