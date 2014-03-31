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

ActiveRecord::Schema.define(version: 20140329064315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "names", force: true do |t|
    t.string   "name"
    t.boolean  "only_male"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "name_freq",  default: 0
  end

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "name_id"
    t.string   "surname",          default: ""
    t.string   "email",            default: ""
    t.integer  "sex_id"
    t.integer  "avatar_id"
    t.integer  "country_id"
    t.integer  "city_id"
    t.datetime "profile_birthday"
    t.string   "about",            default: ""
  end

  create_table "relations", force: true do |t|
    t.string   "relation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trees", force: true do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.integer  "relation_id"
    t.boolean  "connected",   default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.integer  "profile_id"
    t.boolean  "admin",      default: false
    t.float    "rating",     default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",      default: ""
    t.string   "password",   default: ""
  end

end
