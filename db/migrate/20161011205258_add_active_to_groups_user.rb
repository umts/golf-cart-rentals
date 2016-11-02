class AddActiveToGroupsUser < ActiveRecord::Migration[5.0]
  def change
    add_column :groups_users, :active, :boolean
  end
end
