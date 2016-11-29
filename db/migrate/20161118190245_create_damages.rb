class CreateDamages < ActiveRecord::Migration[5.0]
  def change
    create_table :damages do |t|
      t.string :type
      t.string :location
      t.string :repaired_by
      t.text :description
      t.text :comments
      t.date :occurred_on
      t.date :repaired_on
      t.decimal :estimated_cost
      t.decimal :actual_cost
      t.references :item
      t.references :rental
      # t.referenecs :hold  Holds not yet completed. Add relationship in future
    end
  end
end
