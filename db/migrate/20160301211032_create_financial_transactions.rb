class CreateFinancialTransactions < ActiveRecord::Migration[4.2]
  def change
    create_table :financial_transactions do |t|
      t.belongs_to :rental, index: true
      t.integer :transactable_id
      t.string :transactable_type
      t.integer :amount, precision: 8, scale: 2
      t.integer :adjustment, precision: 8, scale: 2
      t.text :note_field

      t.timestamps null: false
    end

    add_index :financial_transactions, :transactable_id
  end
end
