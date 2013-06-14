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

ActiveRecord::Schema.define(:version => 7) do

  create_table "customers", :force => true do |t|
    t.integer  "space_id"
    t.integer  "qb_id"
    t.text     "address"
    t.string   "name"
    t.string   "company"
    t.string   "post_code"
    t.string   "country"
    t.string   "state"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "cobot_id"
  end

  create_table "invoices", :force => true do |t|
    t.integer "space_id"
    t.string  "cobot_id"
    t.integer "qb_id"
  end

  create_table "line_items", :force => true do |t|
    t.integer "space_id"
    t.integer "qb_id"
    t.text    "description"
  end

  create_table "spaces", :force => true do |t|
    t.integer  "user_id"
    t.string   "cobot_id"
    t.integer  "qb_id"
    t.text     "address"
    t.string   "name"
    t.string   "company"
    t.string   "post_code"
    t.string   "country"
    t.string   "state"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "qb_account_ref"
  end

  create_table "users", :force => true do |t|
    t.string   "token"
    t.string   "qb_token"
    t.string   "qb_secret"
    t.string   "qb_realm_id"
    t.string   "cobot_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
