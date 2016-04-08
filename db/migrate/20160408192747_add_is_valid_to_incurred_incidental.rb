class AddIsValidToIncurredIncidental < ActiveRecord::Migration
  def change
    # meant to name this migration 'AddIsActive...'
    change_table :incurred_incidentals do |i|
      i.boolean :is_active, default: true
    end
  end
end
