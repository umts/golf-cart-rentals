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

ActiveRecord::Schema.define(version: 20160226153041) do

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

  create_table "permissions", force: :cascade do |t|
    t.string   "controller", limit: 255, null: false
    t.string   "action",     limit: 255, null: false
    t.string   "id_field",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "rentals", force: :cascade do |t|
    t.string   "rental_status",   limit: 255
    t.integer  "user_id",         limit: 4,   null: false
    t.integer  "department_id",   limit: 4,   null: false
    t.integer  "reservation_id",  limit: 4,   null: false
    t.integer  "fee_schedule_id", limit: 4,   null: false
    t.datetime "checked_out_at"
    t.datetime "checked_in_at"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "rentals", ["rental_status"], name: "index_rentals_on_rental_status", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name", limit: 30,                 null: false
    t.string   "last_name",  limit: 30,                 null: false
    t.string   "email",      limit: 255,                null: false
    t.integer  "phone",      limit: 8,                  null: false
    t.integer  "spire_id",   limit: 4,                  null: false
    t.boolean  "active",                 default: true, null: false
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
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
end
