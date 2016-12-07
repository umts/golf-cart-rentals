class DropIncurredIncidentialsDocuments < ActiveRecord::Migration[5.0]
  def change
    drop_table :incurred_incidentals_documents
    add_column :documents, :documentable_id, :integer
    add_column :documents, :documentable_type, :string
  end
end
