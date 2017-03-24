class ChangeColumnName < ActiveRecord::Migration[5.0]
  def change
    rename_column :financial_transaction, :amount, :initial_amount
  end
end
