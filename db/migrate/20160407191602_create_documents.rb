class CreateDocuments < ActiveRecord::Migration
  def change
    create_table :documents do |t|
      t.string :filename, null: false
      t.belongs_to :incurred_incidental, index:true

      t.timestamps null: false
    end
  end
end
