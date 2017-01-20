class AddIncurredIncidentalIdToDamage < ActiveRecord::Migration[5.0]
  def change
    add_column :damages, :incurred_incidental_id, :integer
    add_column :damages, :hold_id, :integer
    
    remove_column :damages, :rental_id, :integer
    remove_column :damages, :item_id, :integer
    remove_column :damages, :comments, :text
    remove_column :damages, :type, :string
  end
end
