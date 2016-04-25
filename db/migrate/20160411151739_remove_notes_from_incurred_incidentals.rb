class RemoveNotesFromIncurredIncidentals < ActiveRecord::Migration
  def change
    remove_column :incurred_incidentals, :notes, :text
  end
end
