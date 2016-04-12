class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :filename, null: false

      t.timestamps null: false
    end

    create_table :incurred_incidentals_documents do |t|
      t.references :incurred_incidental, index: true, null: false
      t.references :document, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :incurred_incidentals_documents, :incurred_incidentals, name: 'fk_incurred_incidentals_documents_incurred_incidentals'
    add_foreign_key :incurred_incidentals_documents, :documents, name: 'fk_incurred_incidentals_documents_documents'
    add_index :incurred_incidentals_documents, [:incurred_incidental_id, :document_id], unique: true, name: "index_on_incidentals_documents_id"
  end
end
