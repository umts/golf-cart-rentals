class CreateIncurredIncidentals < ActiveRecord::Migration
  def change
    create_table :incurred_incidentals do |t|
      t.references :incidental_type, index: true, foreign_key: true
      t.decimal :times_modified
      t.text :notes

      t.timestamps null: false
    end
  end
end
