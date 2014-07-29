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

ActiveRecord::Schema.define(version: 20140729062749) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "adminpack"

  create_table "names", force: true do |t|
    t.string   "name"
    t.boolean  "only_male"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "name_freq",   default: 0
    t.boolean  "is_approved", default: false
    t.integer  "sex_id"
  end

  create_table "profile_data", force: true do |t|
    t.integer  "profile_id"
    t.integer  "creator_id"
    t.string   "middle_name"
    t.string   "last_name"
    t.string   "country_id"
    t.string   "city_id"
    t.text     "biography"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profile_keys", force: true do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.integer  "name_id"
    t.integer  "relation_id"
    t.integer  "is_profile_id"
    t.integer  "is_name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "name_id"
    t.string   "surname",              default: ""
    t.string   "email",                default: ""
    t.integer  "sex_id"
    t.integer  "avatar_id"
    t.integer  "country_id"
    t.integer  "city_id"
    t.datetime "profile_birthday"
    t.string   "about",                default: ""
    t.datetime "profile_deathday"
    t.string   "country"
    t.string   "city"
    t.string   "middle_name"
    t.string   "relation_description"
  end

  create_table "relations", force: true do |t|
    t.string   "relation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relation_id"
    t.string   "relation_rod_padej",    default: ""
    t.integer  "reverse_relation_id"
    t.string   "reverse_relation",      default: ""
    t.integer  "origin_profile_sex_id"
  end

  create_table "trees", force: true do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.integer  "relation_id"
    t.boolean  "connected",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "name_id"
    t.integer  "is_profile_id"
    t.integer  "is_name_id"
    t.integer  "is_sex_id"
  end

  create_table "users", force: true do |t|
    t.integer  "profile_id"
    t.boolean  "admin",                  default: false
    t.float    "rating",                 default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "password_digest"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
