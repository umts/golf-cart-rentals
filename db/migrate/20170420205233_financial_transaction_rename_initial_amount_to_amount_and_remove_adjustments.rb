class FinancialTransactionRenameInitialAmountToAmountAndRemoveAdjustments < ActiveRecord::Migration[5.0]
  def change
    rename_column :financial_transactions, :initial_amount, :amount
    remove_column :financial_transactions, :adjustment
  end
end
