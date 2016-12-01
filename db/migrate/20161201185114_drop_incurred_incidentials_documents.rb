class DropIncurredIncidentialsDocuments < ActiveRecord::Migration[5.0]
  def change
    drop_table :incurred_incidentals_documents
  end
end
