class RemoveNotesFromIncurredIncidentals < ActiveRecord::Migration[4.2]
  def change
    remove_column :incurred_incidentals, :notes, :text
  end
end
