class RemoveUserReferenceFromDepartment < ActiveRecord::Migration[4.2]
  def change
    remove_column :departments, :user_id
  end
end
