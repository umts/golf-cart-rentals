class CreateDigitalSignatures < ActiveRecord::Migration
  def change
    create_table :digital_signatures do |t|
      t.text :image
      t.string :intent
      t.references :rental

      t.timestamps null: false
    end
  end
end
