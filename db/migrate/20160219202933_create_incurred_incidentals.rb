class CreateIncurredIncidentals < ActiveRecord::Migration
  def change
    create_table :incurred_incidentals do |t|
      t.references :incidental_type, index: true
      t.decimal :times_modified
      t.text :notes
      t.references :rental, index: true

      t.timestamps null: false
    end
  end
end
