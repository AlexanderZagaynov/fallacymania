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

ActiveRecord::Schema.define(version: 20160101010101) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fallacies", force: :cascade do |t|
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "slug",       limit: 255, null: false
  end

  add_index "fallacies", ["slug"], name: "index_fallacies_on_slug", unique: true, using: :btree

  create_table "fallacy_translations", force: :cascade do |t|
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "fallacy_id",              null: false
    t.string   "locale",      limit: 10,  null: false
    t.string   "name",        limit: 255, null: false
    t.text     "description",             null: false
    t.text     "example",                 null: false
  end

  add_index "fallacy_translations", ["fallacy_id"], name: "index_fallacy_translations_on_fallacy_id", using: :btree
  add_index "fallacy_translations", ["locale"], name: "index_fallacy_translations_on_locale", using: :btree

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50,  null: false
    t.string   "slug",           limit: 255, null: false
    t.string   "scope",          limit: 255
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "user_sessions", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "user_id",               null: false
    t.string   "token",      limit: 32, null: false
  end

  add_index "user_sessions", ["user_id"], name: "index_user_sessions_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "name",       limit: 255, default: "",    null: false
    t.boolean  "guest",                  default: false, null: false
  end

  add_index "users", ["guest"], name: "index_users_on_guest", using: :btree

end
