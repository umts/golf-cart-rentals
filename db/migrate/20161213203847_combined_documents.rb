class CombinedDocuments < ActiveRecord::Migration[5.0]
  def change
    create_table "documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
      t.string   "filename",          null: false
      t.datetime "created_at",        null: false
      t.datetime "updated_at",        null: false
      t.integer  "documentable_id"
      t.string   "documentable_type"
      t.string   "description"
      t.integer  "filetype"
      t.string   "original_filename"
    end
  end
end
