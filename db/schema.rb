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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140321171828) do

  create_table "accounts", :force => true do |t|
    t.string "username"
    t.string "password_digest"
    t.string "email"
  end

  create_table "diabetics", :force => true do |t|
    t.string  "name",                          :null => false
    t.string  "email",                         :null => false
    t.date    "birthday",                      :null => false
    t.boolean "confirmed",  :default => false
    t.integer "doctor_id"
    t.integer "account_id"
  end

  create_table "doctors", :force => true do |t|
    t.string "name"
    t.string "fax"
    t.text   "comments"
    t.string "email"
  end

  create_table "preferences", :force => true do |t|
    t.boolean "reminders"
    t.integer "frequency"
    t.integer "diabetic_id"
  end

  create_table "records", :force => true do |t|
    t.integer  "diabetic_id"
    t.string   "weight"
    t.string   "glucose"
    t.datetime "taken_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "comment"
  end

end
