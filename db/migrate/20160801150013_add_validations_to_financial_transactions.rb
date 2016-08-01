class AddValidationsToFinancialTransactions < ActiveRecord::Migration
  def change
    change_column(:financial_transactions, :amount, :integer, null: false, default: 0)
    change_column(:financial_transactions, :adjustment, :integer, null: false, default: 0)
  end
end
