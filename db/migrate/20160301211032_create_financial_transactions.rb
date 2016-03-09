class CreateFinancialTransactions < ActiveRecord::Migration
  def change
    create_table :financial_transactions do |t|
      t.belongs_to :financial_type, index: true
      t.integer :amount, precision: 8, scale: 2
      t.integer :adjustment, precision: 8, scale: 2
      t.text :note_field

      t.timestamps null: false
    end

    #create_table :transaction_types do |t|

    #end
  end
end
