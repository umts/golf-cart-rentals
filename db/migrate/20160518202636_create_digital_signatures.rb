class CreateDigitalSignatures < ActiveRecord::Migration[4.2]
  def change
    create_table :digital_signatures do |t|
      t.text :image
      t.string :intent
      t.references :rental
      t.integer :author

      t.timestamps null: false
    end
  end
end
