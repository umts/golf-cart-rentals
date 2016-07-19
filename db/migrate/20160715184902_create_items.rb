class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
    	t.string :name, unique:true, null: false
    	t.string :item_type_id, null: false
    	t.string :uuid, null: false
      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :items, :uuid, unique: true
    add_index :items, :item_type_id
    add_index :items, :deleted_at
  end
end
