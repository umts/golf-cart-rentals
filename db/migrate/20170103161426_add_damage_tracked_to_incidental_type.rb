class AddDamageTrackedToIncidentalType < ActiveRecord::Migration[5.0]
  def change
    add_column :incidental_types, :damage_tracked, :boolean
  end
end
