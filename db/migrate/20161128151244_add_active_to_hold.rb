class AddActiveToHold < ActiveRecord::Migration[5.0]
  def change
    add_column :holds, :active, :boolean
  end
end
