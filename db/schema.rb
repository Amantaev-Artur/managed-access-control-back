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

ActiveRecord::Schema.define(version: 2024_04_08_104212) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "access_types", force: :cascade do |t|
    t.string "slug", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "accesses", force: :cascade do |t|
    t.integer "author_id"
    t.string "size", null: false
    t.jsonb "data"
    t.bigint "access_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_type_id"], name: "index_accesses_on_access_type_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "author_id"
    t.string "name"
    t.string "description"
    t.text "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "groups_accesses", force: :cascade do |t|
    t.bigint "access_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_id", "group_id"], name: "index_groups_accesses_on_access_id_and_group_id", unique: true
    t.index ["access_id"], name: "index_groups_accesses_on_access_id"
    t.index ["group_id"], name: "index_groups_accesses_on_group_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "name", default: "", null: false
    t.string "nickname", default: "", null: false
    t.string "priv_key", default: "", null: false
    t.string "pub_key", default: "", null: false
    t.string "image", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_groups", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_users_groups_on_group_id"
    t.index ["user_id", "group_id"], name: "index_users_groups_on_user_id_and_group_id", unique: true
    t.index ["user_id"], name: "index_users_groups_on_user_id"
  end

  add_foreign_key "accesses", "access_types"
  add_foreign_key "groups_accesses", "accesses", on_delete: :cascade
  add_foreign_key "groups_accesses", "groups", on_delete: :cascade
  add_foreign_key "users_groups", "groups", on_delete: :cascade
  add_foreign_key "users_groups", "users", on_delete: :cascade
end
