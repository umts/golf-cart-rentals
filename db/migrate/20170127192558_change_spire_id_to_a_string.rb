class ChangeSpireIdToAString < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :spire_id, :string
  end
end
