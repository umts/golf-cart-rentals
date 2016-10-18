class ChangeUserPhoneFromIntToString < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :phone, :string
  end
end
