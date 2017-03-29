class RenameAmountToInitialAmount < ActiveRecord::Migration[5.0]
  def change
    rename_column :financial_transactions, :amount, :initial_amount
  end
end
