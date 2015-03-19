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

ActiveRecord::Schema.define(version: 20150319052021) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentication_providers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "authentication_providers", ["name"], name: "index_name_on_authentication_providers", using: :btree

  create_table "direction_sets", force: :cascade do |t|
    t.integer  "notification_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "direction_sets", ["notification_id"], name: "index_direction_sets_on_notification_id", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string  "name"
    t.string  "street"
    t.string  "city"
    t.string  "state"
    t.integer "zipcode"
    t.boolean "active"
    t.decimal "lat",            precision: 10, scale: 6
    t.decimal "lng",            precision: 10, scale: 6
    t.boolean "saved_location"
    t.integer "user_id"
  end

  add_index "locations", ["user_id"], name: "index_locations_on_user_id", using: :btree

  create_table "notifications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "to"
    t.integer  "from"
    t.datetime "send_time"
    t.datetime "sent_time"
    t.boolean  "sent"
    t.string   "source"
    t.string   "aasm_state"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "phone_numbers", force: :cascade do |t|
    t.string   "number"
    t.boolean  "active"
    t.boolean  "verified"
    t.datetime "verified_at"
    t.integer  "user_id"
    t.string   "name"
  end

  add_index "phone_numbers", ["user_id"], name: "index_phone_numbers_on_user_id", using: :btree

  create_table "routes", force: :cascade do |t|
    t.integer "direction_set_id"
    t.integer "option"
    t.string  "start_address"
    t.string  "end_address"
    t.time    "departure_time"
    t.time    "arrival_time"
    t.string  "distance"
    t.string  "duration"
  end

  add_index "routes", ["direction_set_id"], name: "index_routes_on_direction_set_id", using: :btree

  create_table "steps", force: :cascade do |t|
    t.integer  "route_id"
    t.string   "distance"
    t.string   "duration"
    t.text     "instructions"
    t.string   "travel_mode"
    t.string   "arrival_stop"
    t.time     "arrival_time"
    t.string   "departure_stop"
    t.time     "departure_time"
    t.string   "headsign"
    t.string   "trans_name"
    t.string   "trans_short_name"
    t.string   "trans_type"
    t.integer  "trans_stops"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "steps", ["route_id"], name: "index_steps_on_route_id", using: :btree

  create_table "user_authentications", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "authentication_provider_id"
    t.string   "uid"
    t.string   "token"
    t.datetime "token_expires_at"
    t.text     "params"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "user_authentications", ["authentication_provider_id"], name: "index_user_authentications_on_authentication_provider_id", using: :btree
  add_index "user_authentications", ["user_id"], name: "index_user_authentications_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "image"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "direction_sets", "notifications"
  add_foreign_key "locations", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "phone_numbers", "users"
  add_foreign_key "routes", "direction_sets"
  add_foreign_key "steps", "routes"
end
