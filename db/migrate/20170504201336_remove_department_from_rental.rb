class RemoveDepartmentFromRental < ActiveRecord::Migration[5.0]
  def change
    remove_column :rentals, :department_id
  end
end
