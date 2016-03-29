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

ActiveRecord::Schema.define(version: 20160329074453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",           limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "logged_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "common_logs", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "log_type"
    t.integer  "log_id"
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "base_profile_id"
    t.integer  "relation_id"
  end

  add_index "common_logs", ["profile_id"], name: "index_common_logs_on_profile_id", using: :btree
  add_index "common_logs", ["user_id"], name: "index_common_logs_on_user_id", using: :btree

  create_table "connected_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "with_user_id"
    t.boolean  "connected",            default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "connection_id"
    t.integer  "rewrite_profile_id"
    t.integer  "overwrite_profile_id"
  end

  add_index "connected_users", ["user_id"], name: "index_connected_users_on_user_id", using: :btree
  add_index "connected_users", ["with_user_id"], name: "index_connected_users_on_with_user_id", using: :btree

  create_table "connection_logs", force: :cascade do |t|
    t.integer  "connected_at"
    t.integer  "current_user_id"
    t.integer  "with_user_id"
    t.string   "table_name",      limit: 255
    t.integer  "table_row"
    t.string   "field",           limit: 255
    t.integer  "written"
    t.integer  "overwritten"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connection_logs", ["current_user_id"], name: "index_connection_logs_on_current_user_id", using: :btree
  add_index "connection_logs", ["with_user_id"], name: "index_connection_logs_on_with_user_id", using: :btree

  create_table "connection_requests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "with_user_id"
    t.integer  "confirm"
    t.boolean  "done",          default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "connection_id"
  end

  add_index "connection_requests", ["user_id"], name: "index_connection_requests_on_user_id", using: :btree
  add_index "connection_requests", ["with_user_id"], name: "index_connection_requests_on_with_user_id", using: :btree

  create_table "counters", force: :cascade do |t|
    t.integer  "invites",     default: 0
    t.integer  "disconnects", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "deletion_logs", force: :cascade do |t|
    t.integer  "log_number"
    t.integer  "current_user_id"
    t.string   "table_name",      limit: 255
    t.integer  "table_row"
    t.string   "field",           limit: 255
    t.integer  "written"
    t.integer  "overwritten"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "deletion_logs", ["current_user_id"], name: "index_deletion_logs_on_current_user_id", using: :btree
  add_index "deletion_logs", ["log_number"], name: "index_deletion_logs_on_log_number", using: :btree

  create_table "event_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "type_number"
  end

  create_table "log_types", force: :cascade do |t|
    t.integer  "type_number"
    t.string   "table_name",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "log_types", ["type_number"], name: "index_log_types_on_type_number", using: :btree

  create_table "messages", force: :cascade do |t|
    t.text     "text"
    t.integer  "sender_id",                        null: false
    t.integer  "receiver_id",                      null: false
    t.boolean  "read",             default: false
    t.boolean  "sender_deleted",   default: false
    t.boolean  "receiver_deleted", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "important",        default: false
  end

  create_table "names", force: :cascade do |t|
    t.string   "name",           limit: 255
    t.boolean  "only_male"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "name_freq",                  default: 0
    t.boolean  "is_approved",                default: false
    t.integer  "sex_id"
    t.integer  "parent_name_id"
    t.integer  "search_name_id"
    t.integer  "status_id",                  default: 0
  end

  add_index "names", ["name", "sex_id"], name: "index_names_on_name_and_sex_id", unique: true, using: :btree
  add_index "names", ["name"], name: "index_names_on_name", using: :btree
  add_index "names", ["only_male"], name: "index_names_on_only_male", using: :btree
  add_index "names", ["status_id"], name: "index_names_on_status_id", using: :btree

  create_table "pending_users", force: :cascade do |t|
    t.integer  "status",       default: 0
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "updated_data"
  end

  create_table "profile_data", force: :cascade do |t|
    t.integer  "profile_id"
    t.string   "last_name",       limit: 255
    t.text     "biography"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "birthday",        limit: 255
    t.string   "country",         limit: 255
    t.string   "city",            limit: 255
    t.integer  "deleted",                     default: 0
    t.string   "avatar_mongo_id", limit: 255
    t.string   "photos",                      default: [], array: true
    t.string   "deathdate"
    t.string   "prev_last_name"
    t.string   "birth_place"
  end

  add_index "profile_data", ["profile_id"], name: "index_profile_data_on_profile_id", using: :btree

  create_table "profile_keys", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.integer  "name_id"
    t.integer  "relation_id"
    t.integer  "is_profile_id"
    t.integer  "is_name_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "deleted",       default: 0
  end

  add_index "profile_keys", ["profile_id"], name: "index_profile_keys_on_profile_id", using: :btree
  add_index "profile_keys", ["user_id"], name: "index_profile_keys_on_user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "name_id"
    t.integer  "sex_id"
    t.integer  "tree_id"
    t.integer  "display_name_id"
    t.integer  "deleted",         default: 0
  end

  add_index "profiles", ["name_id"], name: "index_profiles_on_name_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "relations", force: :cascade do |t|
    t.string   "relation",              limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "relation_id"
    t.string   "relation_rod_padej",    limit: 255, default: ""
    t.integer  "reverse_relation_id"
    t.string   "reverse_relation",      limit: 255, default: ""
    t.integer  "origin_profile_sex_id"
  end

  add_index "relations", ["relation_id"], name: "index_relations_on_relation_id", using: :btree

  create_table "search_results", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "found_user_id"
    t.integer  "profile_id"
    t.integer  "found_profile_id"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "found_profile_ids",                array: true
    t.integer  "searched_profile_ids",             array: true
    t.integer  "counts",                           array: true
    t.integer  "connection_id"
    t.integer  "pending_connect",      default: 0
    t.integer  "searched_connected",               array: true
    t.integer  "founded_connected",                array: true
  end

  add_index "search_results", ["profile_id"], name: "index_search_results_on_profile_id", using: :btree
  add_index "search_results", ["user_id"], name: "index_search_results_on_user_id", using: :btree

  create_table "search_service_logs", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.integer  "search_event"
    t.float    "time",                                default: 0.0
    t.integer  "connected_users",                     default: [],  array: true
    t.integer  "searched_profiles"
    t.float    "ave_profile_search_time",             default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "all_tree_profiles",                   default: 0
    t.integer  "all_profiles",                        default: 0
    t.integer  "user_id"
  end

  create_table "similars_founds", force: :cascade do |t|
    t.integer  "user_id",           null: false
    t.integer  "first_profile_id",  null: false
    t.integer  "second_profile_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "similars_founds", ["first_profile_id"], name: "index_similars_founds_on_first_profile_id", using: :btree
  add_index "similars_founds", ["user_id"], name: "index_similars_founds_on_user_id", using: :btree

  create_table "similars_logs", force: :cascade do |t|
    t.integer  "connected_at"
    t.integer  "current_user_id"
    t.string   "table_name",      limit: 255
    t.integer  "table_row"
    t.string   "field",           limit: 255
    t.integer  "written"
    t.integer  "overwritten"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "similars_logs", ["current_user_id"], name: "index_similars_logs_on_current_user_id", using: :btree

  create_table "trees", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "profile_id"
    t.integer  "relation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "name_id"
    t.integer  "is_profile_id"
    t.integer  "is_name_id"
    t.integer  "is_sex_id"
    t.integer  "display_name_id"
    t.integer  "is_display_name_id"
    t.integer  "deleted",            default: 0
  end

  add_index "trees", ["profile_id"], name: "index_trees_on_profile_id", using: :btree
  add_index "trees", ["user_id"], name: "index_trees_on_user_id", using: :btree

  create_table "updates_events", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "image",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "updates_feeds", force: :cascade do |t|
    t.integer  "user_id",          null: false
    t.integer  "update_id",        null: false
    t.integer  "agent_user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "read"
    t.integer  "agent_profile_id"
    t.integer  "who_made_event"
  end

  create_table "users", force: :cascade do |t|
    t.integer  "profile_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "password_digest",        limit: 255
    t.boolean  "is_locked",                          default: false
    t.string   "access_token",           limit: 255
    t.integer  "connected_users",                    default: [],                 array: true
    t.integer  "double",                             default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["profile_id"], name: "index_users_on_profile_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "weafam_settings", force: :cascade do |t|
    t.integer  "certain_koeff",                   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "certain_connect",     default: 4
    t.integer  "exclusion_relations",                          array: true
  end

  create_table "weafam_stats", force: :cascade do |t|
    t.integer  "users",           default: 0
    t.integer  "users_male",      default: 0
    t.integer  "users_female",    default: 0
    t.integer  "profiles",        default: 0
    t.integer  "profiles_male",   default: 0
    t.integer  "profiles_female", default: 0
    t.integer  "trees",           default: 0
    t.integer  "invitations",     default: 0
    t.integer  "requests",        default: 0
    t.integer  "connections",     default: 0
    t.integer  "refuse_requests", default: 0
    t.integer  "disconnections",  default: 0
    t.integer  "similars_found",  default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "requests_wait",   default: 0
  end

end
