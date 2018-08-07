class AddValidationsToFinancialTransactions < ActiveRecord::Migration[4.2]
  def change
    change_column_null(:financial_transactions, :amount, false, 0)
    change_column_null(:financial_transactions, :adjustment, false, 0)
    change_column(:financial_transactions, :amount, :integer, default: 0)
    change_column(:financial_transactions, :adjustment, :integer, default: 0)
  end
end
