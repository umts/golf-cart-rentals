class AddActiveToPermissionAndGroupsPermission < ActiveRecord::Migration[5.0]
  def change
    add_column :permissions, :active, :boolean, default: true
    add_column :groups_permission, :active, :boolean, default: true
  end
end
