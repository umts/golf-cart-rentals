class RentalsHasManyRentalsItems < ActiveRecord::Migration[5.0]
  def change
    create_table :rentals_items do |t|
      t.references :rentals
      t.references :items
      t.string :reservation_id
      t.references :item_types
      t.timestamps
    end

    add_column :incurred_incidentals, :item_id, :integer

    remove_column :rentals, :item_id
    remove_column :rentals, :item_type_id
  end
end
