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

ActiveRecord::Schema.define(version: 20140925171955) do

  create_table "acceptances", force: true do |t|
    t.integer  "amount"
    t.text     "note"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "person_id"
    t.integer  "purchase_id"
  end

  create_table "people", force: true do |t|
    t.string   "name"
    t.integer  "account_number"
    t.integer  "sort_code"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
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

  add_index "people", ["email"], name: "index_people_on_email", unique: true
  add_index "people", ["reset_password_token"], name: "index_people_on_reset_password_token", unique: true
  add_index "people", ["unlock_token"], name: "index_people_on_unlock_token", unique: true

  create_table "purchases", force: true do |t|
    t.string   "name"
    t.integer  "amount"
    t.text     "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "person_id"
  end

end
