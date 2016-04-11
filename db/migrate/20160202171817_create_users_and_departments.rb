class CreateUsersAndDepartments < ActiveRecord::Migration
  def change
  	create_table :users do |t|
      t.string :first_name, limit: 30, null: false
      t.string :last_name, limit: 30, null: false
      t.string :username, limit: 30, null: false
      t.string :email, limit: 255, null: false
      t.integer :phone, limit: 8, null: false
      t.integer :spire_id, null: false
      t.boolean :active, default: true, null: false

      # standard audit data
      t.timestamps null: false
    end

    add_index(:users, :spire_id, unique: true)
  end

  create_table :departments do |t|
    t.string :name, null: false
    t.boolean :active, default: true, null: false

    # standard audit data
    t.timestamps null: false
  end
end
