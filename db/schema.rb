# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170911185405) do

  create_table "damages", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "location"
    t.string "repaired_by"
    t.text "description"
    t.date "occurred_on"
    t.date "repaired_on"
    t.decimal "estimated_cost", precision: 10
    t.decimal "actual_cost", precision: 10
    t.integer "incurred_incidental_id"
    t.integer "hold_id"
  end

  create_table "departments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "documents", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "filename", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "documentable_id"
    t.string "documentable_type"
    t.string "description"
    t.integer "filetype"
    t.string "original_filename"
  end

  create_table "financial_transactions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "rental_id"
    t.integer "transactable_id"
    t.string "transactable_type"
    t.integer "amount", default: 0, null: false
    t.text "note_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rental_id"], name: "index_financial_transactions_on_rental_id"
    t.index ["transactable_id"], name: "index_financial_transactions_on_transactable_id"
  end

  create_table "groups", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_permissions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "group_id"
    t.integer "permission_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["group_id", "permission_id"], name: "index_groups_permissions_on_group_id_and_permission_id", unique: true
    t.index ["group_id"], name: "index_groups_permissions_on_group_id"
    t.index ["permission_id"], name: "index_groups_permissions_on_permission_id"
  end

  create_table "groups_users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "group_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_groups_users_on_group_id"
    t.index ["user_id"], name: "index_groups_users_on_user_id"
  end

  create_table "holds", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "hold_reason"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "item_type_id"
    t.integer "item_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active"
  end

  create_table "incidental_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.string "description"
    t.decimal "base", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "damage_tracked"
  end

  create_table "incurred_incidentals", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "incidental_type_id"
    t.integer "rental_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.integer "item_id"
    t.index ["incidental_type_id"], name: "index_incurred_incidentals_on_incidental_type_id"
    t.index ["rental_id"], name: "index_incurred_incidentals_on_rental_id"
  end

  create_table "item_types", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.float "base_fee", limit: 24
    t.float "fee_per_day", limit: 24
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uuid", null: false
    t.index ["uuid"], name: "index_item_types_on_uuid", unique: true
  end

  create_table "items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.string "item_type_id", null: false
    t.string "uuid", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["deleted_at"], name: "index_items_on_deleted_at"
    t.index ["item_type_id"], name: "index_items_on_item_type_id"
    t.index ["uuid"], name: "index_items_on_uuid", unique: true
  end

  create_table "notes", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "note"
    t.string "noteable_type"
    t.integer "noteable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable_type_and_noteable_id"
  end

  create_table "payments", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "payment_type"
    t.string "contact_name"
    t.string "contact_phone"
    t.string "contact_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference"
  end

  create_table "permissions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "controller", null: false
    t.string "action", null: false
    t.string "id_field"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "active", default: true
  end

  create_table "rentals", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "rental_status", null: false
    t.datetime "dropped_off_at"
    t.datetime "picked_up_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.string "pickup_name"
    t.string "dropoff_name"
    t.string "pickup_phone_number"
    t.string "dropoff_phone_number"
    t.integer "creator_id"
    t.integer "renter_id"
    t.index ["rental_status"], name: "index_rentals_on_rental_status"
  end

  create_table "rentals_items", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "rental_id"
    t.integer "item_id"
    t.string "reservation_id"
    t.integer "item_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_rentals_items_on_item_id"
    t.index ["item_type_id"], name: "index_rentals_items_on_item_type_id"
    t.index ["rental_id"], name: "index_rentals_items_on_rental_id"
  end

  create_table "users", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "first_name", limit: 30, null: false
    t.string "last_name", limit: 30, null: false
    t.string "email", null: false
    t.string "phone", null: false
    t.string "spire_id", null: false
    t.integer "department_id"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spire_id"], name: "index_users_on_spire_id", unique: true
  end

  create_table "versions", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "groups_permissions", "groups", name: "fk_groups_permissions_groups"
  add_foreign_key "groups_permissions", "permissions", name: "fk_groups_permissions_permissions"
  add_foreign_key "groups_users", "groups", name: "fk_groups_users_groups"
  add_foreign_key "groups_users", "users", name: "fk_groups_users_users"
end
