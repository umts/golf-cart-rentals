class CreateDepartmentsUsers < ActiveRecord::Migration
  def change
    create_table :departments_users do |t|
      t.references :department, index: true, null: false
      t.references :user, index: true, null: false

      # standard audit data
      t.timestamps null: false
    end

    add_foreign_key :departments_users, :departments, name: 'fk_departments_users_groups'
    add_foreign_key :departments_users, :users, name: 'fk_departments_users'
    add_index(:departments_users, [:department_id, :user_id], unique: true)

  end
end
