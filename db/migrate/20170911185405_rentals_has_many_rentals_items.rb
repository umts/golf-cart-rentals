class RentalsHasManyRentalsItems < ActiveRecord::Migration[5.0]
  def change
    create_table :rentals_items do |t|
      t.references :rental
      t.references :item
      t.string :reservation_id
      t.references :item_type
      t.timestamps
    end

    add_column :incurred_incidentals, :item_id, :integer

    remove_column :rentals, :item_id, :integer
    remove_column :rentals, :item_type_id, :integer
    remove_column :rentals, :reservation_id, :string
  end
end
