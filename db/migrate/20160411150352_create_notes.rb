class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.string :note
      t.references :noteable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
