class CreatePayments < ActiveRecord::Migration[5.0]
  def change
    create_table :payments do |t|
      t.integer :payment_type
      t.string :contact_name
      t.string :contact_phone
      t.string :contact_email
      t.timestamps 
    end
  end
end
