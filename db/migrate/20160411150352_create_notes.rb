class CreateNotes < ActiveRecord::Migration[4.2]
  def change
    create_table :notes do |t|
      t.string :note
      t.references :noteable, polymorphic: true, index: true
      t.timestamps null: false
    end
  end
end
