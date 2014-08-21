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

ActiveRecord::Schema.define(version: 20140821184116) do

  create_table "agreements", force: true do |t|
    t.integer  "user_id"
    t.integer  "contest_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "agreements", ["contest_id"], name: "index_agreements_on_contest_id"
  add_index "agreements", ["user_id"], name: "index_agreements_on_user_id"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_type_id"
  end

  add_index "categories", ["category_type_id"], name: "index_categories_on_category_type_id"

  create_table "categories_contests", id: false, force: true do |t|
    t.integer "category_id"
    t.integer "contest_id"
  end

  create_table "category_types", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "minimum_files"
    t.integer  "maximum_files"
    t.boolean  "has_url"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "category_types_file_types", force: true do |t|
    t.integer "category_type_id"
    t.integer "file_type_id"
  end

  create_table "contest_rules", force: true do |t|
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contests", force: true do |t|
    t.integer  "year"
    t.string   "name"
    t.datetime "open_date"
    t.datetime "close_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "contest_rules_id"
  end

  create_table "countries", force: true do |t|
    t.string   "name"
    t.string   "iso"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "entries", force: true do |t|
    t.integer  "category_id"
    t.integer  "user_id"
    t.boolean  "judged"
    t.integer  "place_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "url"
    t.string   "order_number"
    t.integer  "contest_id"
    t.string   "unique_hash"
  end

  add_index "entries", ["category_id"], name: "index_entries_on_category_id"
  add_index "entries", ["contest_id"], name: "index_entries_on_contest_id"
  add_index "entries", ["place_id"], name: "index_entries_on_place_id"
  add_index "entries", ["user_id"], name: "index_entries_on_user_id"

  create_table "file_types", force: true do |t|
    t.string   "name"
    t.string   "extension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "filename"
    t.string   "original_filename"
    t.integer  "size"
    t.string   "location"
    t.integer  "entry_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unique_hash"
    t.string   "caption"
    t.integer  "number"
  end

  create_table "places", force: true do |t|
    t.string   "name"
    t.integer  "sequence_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "states", force: true do |t|
    t.string   "name"
    t.string   "iso"
    t.integer  "country_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "street"
    t.string   "city"
    t.string   "zip"
    t.integer  "state_id"
    t.string   "day_phone"
    t.string   "evening_phone"
    t.string   "employer"
    t.boolean  "admin",                  default: false
    t.string   "school"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
