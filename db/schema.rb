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

ActiveRecord::Schema.define(version: 20150331162914) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "acceptances", force: true do |t|
    t.integer  "amount"
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.integer  "purchase_id"
  end

  add_index "acceptances", ["person_id", "purchase_id"], name: "index_acceptances_on_person_id_and_purchase_id", unique: true, using: :btree

  create_table "minimal_transactions", force: true do |t|
    t.integer "from_person_id"
    t.integer "to_person_id"
    t.integer "amount"
    t.boolean "speculative",    default: false
  end

  create_table "owednesses", force: true do |t|
    t.integer "from_person_id"
    t.integer "to_person_id"
    t.integer "amount"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.string   "account_number"
    t.string   "sort_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0, null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.text     "encrypted_password"
    t.text     "email"
  end

  add_index "people", ["email"], name: "index_people_on_email", unique: true, using: :btree
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true, using: :btree
  add_index "people", ["unlock_token"], name: "index_people_on_unlock_token", unique: true, using: :btree

  create_table "purchases", force: true do |t|
    t.string   "name"
    t.integer  "amount"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.date     "date"
  end

end
