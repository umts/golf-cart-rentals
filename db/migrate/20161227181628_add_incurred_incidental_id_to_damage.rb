class AddIncurredIncidentalIdToDamage < ActiveRecord::Migration[5.0]
  def change
    add_column :damages, :incurred_incidental_id, :integer
  end
end
