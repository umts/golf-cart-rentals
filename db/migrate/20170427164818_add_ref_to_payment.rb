class AddRefToPayment < ActiveRecord::Migration[5.0]
  def change
    add_column :payments, :reference, :string
  end
end
