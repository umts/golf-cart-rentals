class CreateGroupsAndPermissions < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name, null: false
      t.string :description, null: false

      t.timestamps null: false
    end

    create_table :groups_users do |t|
      t.references :group, index: true, null: false
      t.references :user, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :groups_users, :groups, name: 'fk_groups_users_groups'
    add_foreign_key :groups_users, :users, name: 'fk_groups_users_users'
    add_index(:groups_users, [:group_id, :user_id], unique: true)


    create_table :permissions do |t|
      t.string :controller, null: false
      t.string :action, null: false
      t.string :id_field, default: nil

      t.timestamps null: false
    end

    create_table :groups_permissions do |t|
      t.references :group, index: true
      t.references :permission, index: true

      t.timestamps null: false
    end

    add_foreign_key :groups_permissions, :groups, name: 'fk_groups_permissions_groups'
    add_foreign_key :groups_permissions, :permissions, name: 'fk_groups_permissions_permissions'
    add_index(:groups_permissions, [:group_id, :permission_id], unique: true)
  end
end
