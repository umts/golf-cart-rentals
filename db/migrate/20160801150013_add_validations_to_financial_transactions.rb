class AddValidationsToFinancialTransactions < ActiveRecord::Migration
  def change
    change_column_null(:financial_transactions, :amount, false, 0)
    change_column_null(:financial_transactions, :adjustment, false, 0)
  end
end
