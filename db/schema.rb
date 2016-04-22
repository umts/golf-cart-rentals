# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160411151739) do

  create_table "departments", force: :cascade do |t|
    t.string   "name",       limit: 255,                null: false
    t.integer  "user_id",    limit: 4,                  null: false
    t.boolean  "active",                 default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
  end

  add_index "departments", ["user_id"], name: "index_departments_on_user_id", using: :btree

  create_table "documents", force: :cascade do |t|
    t.string   "filename",   limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.string   "description", limit: 255, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "groups_permissions", force: :cascade do |t|
    t.integer  "group_id",      limit: 4
    t.integer  "permission_id", limit: 4
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "groups_permissions", ["group_id", "permission_id"], name: "index_groups_permissions_on_group_id_and_permission_id", unique: true, using: :btree
  add_index "groups_permissions", ["group_id"], name: "index_groups_permissions_on_group_id", using: :btree
  add_index "groups_permissions", ["permission_id"], name: "index_groups_permissions_on_permission_id", using: :btree

  create_table "groups_users", force: :cascade do |t|
    t.integer  "group_id",   limit: 4, null: false
    t.integer  "user_id",    limit: 4, null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "groups_users", ["group_id", "user_id"], name: "index_groups_users_on_group_id_and_user_id", unique: true, using: :btree
  add_index "groups_users", ["group_id"], name: "index_groups_users_on_group_id", using: :btree
  add_index "groups_users", ["user_id"], name: "index_groups_users_on_user_id", using: :btree

  create_table "incidental_types", force: :cascade do |t|
    t.string   "name",                 limit: 255
    t.string   "description",          limit: 255
    t.decimal  "base",                             precision: 10
    t.decimal  "modifier_amount",                  precision: 10
    t.string   "modifier_description", limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  create_table "incurred_incidentals", force: :cascade do |t|
    t.integer  "incidental_type_id", limit: 4
    t.decimal  "times_modified",               precision: 10
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "incurred_incidentals", ["incidental_type_id"], name: "index_incurred_incidentals_on_incidental_type_id", using: :btree

  create_table "incurred_incidentals_documents", force: :cascade do |t|
    t.integer  "incurred_incidental_id", limit: 4, null: false
    t.integer  "document_id",            limit: 4, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "incurred_incidentals_documents", ["document_id"], name: "index_incurred_incidentals_documents_on_document_id", using: :btree
  add_index "incurred_incidentals_documents", ["incurred_incidental_id", "document_id"], name: "index_on_incidentals_documents_id", unique: true, using: :btree
  add_index "incurred_incidentals_documents", ["incurred_incidental_id"], name: "index_incurred_incidentals_documents_on_incurred_incidental_id", using: :btree

  create_table "item_types", force: :cascade do |t|
    t.string   "name",        limit: 255,   null: false
    t.text     "disclaimer",  limit: 65535
    t.float    "base_fee",    limit: 24
    t.float    "fee_per_day", limit: 24
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  create_table "notes", force: :cascade do |t|
    t.string   "note",          limit: 255
    t.integer  "noteable_id",   limit: 4
    t.string   "noteable_type", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

  add_index "notes", ["noteable_type", "noteable_id"], name: "index_notes_on_noteable_type_and_noteable_id", using: :btree

  create_table "permissions", force: :cascade do |t|
    t.string   "controller", limit: 255, null: false
    t.string   "action",     limit: 255, null: false
    t.string   "id_field",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "rentals", force: :cascade do |t|
    t.string   "rental_status",  limit: 255, null: false
    t.integer  "user_id",        limit: 4,   null: false
    t.integer  "department_id",  limit: 4
    t.integer  "reservation_id", limit: 4,   null: false
    t.integer  "item_type_id",   limit: 4,   null: false
    t.datetime "start_date",                 null: false
    t.datetime "end_date",                   null: false
    t.datetime "checked_in_at"
    t.datetime "checked_out_at"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "rentals", ["item_type_id"], name: "index_rentals_on_item_type_id", using: :btree
  add_index "rentals", ["rental_status"], name: "index_rentals_on_rental_status", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name",    limit: 30,                 null: false
    t.string   "last_name",     limit: 30,                 null: false
    t.string   "email",         limit: 255,                null: false
    t.integer  "phone",         limit: 8,                  null: false
    t.integer  "spire_id",      limit: 4,                  null: false
    t.integer  "department_id", limit: 4
    t.boolean  "active",                    default: true, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "users", ["spire_id"], name: "index_users_on_spire_id", unique: true, using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",  limit: 255,   null: false
    t.integer  "item_id",    limit: 4,     null: false
    t.string   "event",      limit: 255,   null: false
    t.string   "whodunnit",  limit: 255
    t.text     "object",     limit: 65535
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

  add_foreign_key "groups_permissions", "groups", name: "fk_groups_permissions_groups"
  add_foreign_key "groups_permissions", "permissions", name: "fk_groups_permissions_permissions"
  add_foreign_key "groups_users", "groups", name: "fk_groups_users_groups"
  add_foreign_key "groups_users", "users", name: "fk_groups_users_users"
  add_foreign_key "incurred_incidentals", "incidental_types"
  add_foreign_key "incurred_incidentals_documents", "documents", name: "fk_incurred_incidentals_documents_documents"
  add_foreign_key "incurred_incidentals_documents", "incurred_incidentals", name: "fk_incurred_incidentals_documents_incurred_incidentals"
end
