class CreateUsersRentalsAndDepartmentsRentals < ActiveRecord::Migration
  def change
    create_table :users_rentals do |t|
      t.references :user, index: true, null: false
      t.references :rental, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :users_rentals, :users, name: 'fk_users_rentals_users'
    add_foreign_key :users_rentals, :rentals, name: 'fk_users_rentals_rentals'
    add_index(:users_rentals, [:user_id, :rental_id], unique: true)


    create_table :departments_rentals do |t|
      t.references :department, index: true, null: false
      t.references :rental, index: true, null: false

      t.timestamps null: false
    end

    add_foreign_key :departments_rentals, :departments, name: 'fk_departments_rentals_departments'
    add_foreign_key :departments_rentals, :rentals, name: 'fk_departments_rentals_rentals'
    add_index(:departments_rentals, [:department_id, :rental_id], unique: true)
  end
end
