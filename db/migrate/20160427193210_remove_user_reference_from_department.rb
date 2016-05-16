class RemoveUserReferenceFromDepartment < ActiveRecord::Migration
  def change
    remove_column :departments, :user_id
  end
end
