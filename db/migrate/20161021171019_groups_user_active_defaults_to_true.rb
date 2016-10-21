class GroupsUserActiveDefaultsToTrue < ActiveRecord::Migration[5.0]
  def change
    change_column :groups_users, :active, :boolean, default: true
  end
end
