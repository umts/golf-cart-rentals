class RemoveModifierDescriptionFromIncidentalType < ActiveRecord::Migration[5.0]
  def change
    remove_column :incidental_types, :modifier_description, :string
  end
end
