class CreateFeeSchedules < ActiveRecord::Migration
  def change
    create_table :fee_schedules do |t|
      t.float :base_amount
      t.float :amount_per_day
      t.references :item_type

      t.timestamps null: false
    end
  end
end
