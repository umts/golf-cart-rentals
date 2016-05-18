class CreateDigitalSignatures < ActiveRecord::Migration
  def change
    create_table :digital_signatures do |t|
      t.string :image
      t.string :intent
      t.references :rental

      t.timestamps null: false
    end
  end
end
