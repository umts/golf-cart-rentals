class CreateFeeSchedules < ActiveRecord::Migration
  def change
    create_table :fee_schedules do |t|
      t.double :base_amount
      t.double :amount_per_day

      t.timestamps null: false
    end
  end
end
