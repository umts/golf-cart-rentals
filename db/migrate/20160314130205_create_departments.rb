class CreateDepartments < ActiveRecord::Migration
  def change
    create_table :departments do |t|
      t.string :name, null: false
      t.references :user, index: true, null: false
      t.boolean :active, default: true, null: false

      # standard audit data
      t.timestamps null: false
    end
  end
end
