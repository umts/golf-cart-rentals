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

ActiveRecord::Schema.define(version: 20161021171019) do

  create_table "departments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                      null: false
    t.boolean  "active",     default: true, null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "digital_signatures", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text     "image",      limit: 65535
    t.integer  "rental_id"
    t.integer  "author"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "intent"
  end

  create_table "documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "filename",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "fee_schedules", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.float    "base_amount",    limit: 24
    t.float    "amount_per_day", limit: 24
    t.integer  "item_type_id"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "financial_transactions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "rental_id"
    t.integer  "transactable_id"
    t.string   "transactable_type"
    t.integer  "amount",                          default: 0, null: false
    t.integer  "adjustment",                      default: 0, null: false
    t.text     "note_field",        limit: 65535
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.index ["rental_id"], name: "index_financial_transactions_on_rental_id", using: :btree
    t.index ["transactable_id"], name: "index_financial_transactions_on_transactable_id", using: :btree
  end

  create_table "groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",        null: false
    t.string   "description", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "groups_permissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "group_id"
    t.integer  "permission_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "active",        default: true
    t.index ["group_id", "permission_id"], name: "index_groups_permissions_on_group_id_and_permission_id", unique: true, using: :btree
    t.index ["group_id"], name: "index_groups_permissions_on_group_id", using: :btree
    t.index ["permission_id"], name: "index_groups_permissions_on_permission_id", using: :btree
  end

  create_table "groups_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "group_id",                  null: false
    t.integer  "user_id",                   null: false
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
    t.index ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true, using: :btree
    t.index ["group_id"], name: "index_groups_users_on_group_id", using: :btree
    t.index ["user_id"], name: "index_groups_users_on_user_id", using: :btree
  end

  create_table "incidental_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "description"
    t.decimal  "base",        precision: 10
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "incurred_incidentals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "incidental_type_id"
    t.decimal  "amount",             precision: 10
    t.integer  "rental_id"
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.index ["incidental_type_id"], name: "index_incurred_incidentals_on_incidental_type_id", using: :btree
    t.index ["rental_id"], name: "index_incurred_incidentals_on_rental_id", using: :btree
  end

  create_table "incurred_incidentals_documents", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "incurred_incidental_id",               null: false
    t.integer  "document_id",                          null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "filename"
    t.binary   "file",                   limit: 65535
    t.index ["document_id"], name: "index_incurred_incidentals_documents_on_document_id", using: :btree
    t.index ["incurred_incidental_id", "document_id"], name: "index_on_incidentals_documents_id", unique: true, using: :btree
    t.index ["incurred_incidental_id"], name: "index_incurred_incidentals_documents_on_incurred_incidental_id", using: :btree
  end

  create_table "item_types", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",                      null: false
    t.text     "disclaimer",  limit: 65535
    t.float    "base_fee",    limit: 24
    t.float    "fee_per_day", limit: 24
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.string   "uuid",                      null: false
    t.index ["uuid"], name: "index_item_types_on_uuid", unique: true, using: :btree
  end

  create_table "items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name",         null: false
    t.string   "item_type_id", null: false
    t.string   "uuid",         null: false
    t.datetime "deleted_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["deleted_at"], name: "index_items_on_deleted_at", using: :btree
    t.index ["item_type_id"], name: "index_items_on_item_type_id", using: :btree
    t.index ["uuid"], name: "index_items_on_uuid", unique: true, using: :btree
  end

  create_table "notes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "note"
    t.string   "noteable_type"
    t.integer  "noteable_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable_type_and_noteable_id", using: :btree
  end

  create_table "payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "payment_type"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_email"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "permissions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "controller",                null: false
    t.string   "action",                    null: false
    t.string   "id_field"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "active",     default: true
  end

  create_table "rentals", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "rental_status",        null: false
    t.integer  "user_id",              null: false
    t.integer  "department_id",        null: false
    t.string   "reservation_id",       null: false
    t.integer  "item_type_id",         null: false
    t.datetime "dropped_off_at"
    t.datetime "picked_up_at"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "item_id",              null: false
    t.string   "pickup_name"
    t.string   "dropoff_name"
    t.string   "pickup_phone_number"
    t.string   "dropoff_phone_number"
    t.index ["item_type_id"], name: "index_rentals_on_item_type_id", using: :btree
    t.index ["rental_status"], name: "index_rentals_on_rental_status", using: :btree
  end

  create_table "reservations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "reservation_type"
    t.string   "reservation_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "item_type_id"
    t.integer  "item_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name",    limit: 30,                null: false
    t.string   "last_name",     limit: 30,                null: false
    t.string   "email",                                   null: false
    t.string   "phone",                                   null: false
    t.integer  "spire_id",                                null: false
    t.integer  "department_id"
    t.boolean  "active",                   default: true, null: false
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["spire_id"], name: "index_users_on_spire_id", unique: true, using: :btree
  end

  create_table "versions", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "item_type",                null: false
    t.integer  "item_id",                  null: false
    t.string   "event",                    null: false
    t.string   "whodunnit"
    t.text     "object",     limit: 65535
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree
  end

  add_foreign_key "groups_permissions", "groups", name: "fk_groups_permissions_groups"
  add_foreign_key "groups_permissions", "permissions", name: "fk_groups_permissions_permissions"
  add_foreign_key "groups_users", "groups", name: "fk_groups_users_groups"
  add_foreign_key "groups_users", "users", name: "fk_groups_users_users"
  add_foreign_key "incurred_incidentals", "incidental_types"
  add_foreign_key "incurred_incidentals", "rentals"
  add_foreign_key "incurred_incidentals_documents", "documents", name: "fk_incurred_incidentals_documents_documents"
  add_foreign_key "incurred_incidentals_documents", "incurred_incidentals", name: "fk_incurred_incidentals_documents_incurred_incidentals"
end
