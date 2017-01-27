class ChangeSpireIdToAString < ActiveRecord::Migration[5.0]
  def change
    change_column :user, :spire_id, :string
  end
end
