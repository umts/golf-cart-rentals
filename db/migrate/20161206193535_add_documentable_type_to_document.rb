class AddDocumentableTypeToDocument < ActiveRecord::Migration[5.0]
  def change
    add_column :documents, :documentable_type, :string
  end
end
