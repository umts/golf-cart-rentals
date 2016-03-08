class CreateIncidentalTypes < ActiveRecord::Migration
  def change
    create_table :incidental_types do |t|
      t.string :name
      t.string :description
      t.decimal :base
      t.decimal :modifier_amount
      t.string :modifier_description

      t.timestamps null: false
    end
  end
end
