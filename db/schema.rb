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

ActiveRecord::Schema.define(version: 20150419010504) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "fallacies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "slug",       null: false
  end

  add_index "fallacies", ["slug"], name: "index_fallacies_on_slug", using: :btree

  create_table "fallacy_samples", force: :cascade do |t|
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "fallacy_id",            null: false
    t.string   "language",    limit: 2, null: false
    t.text     "description"
  end

  add_index "fallacy_samples", ["fallacy_id"], name: "index_fallacy_samples_on_fallacy_id", using: :btree
  add_index "fallacy_samples", ["language"], name: "index_fallacy_samples_on_language", using: :btree

  create_table "fallacy_translations", force: :cascade do |t|
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "fallacy_id",                  null: false
    t.string   "language",          limit: 2, null: false
    t.string   "name",                        null: false
    t.text     "description"
    t.integer  "fallacy_sample_id"
  end

  add_index "fallacy_translations", ["fallacy_id"], name: "index_fallacy_translations_on_fallacy_id", using: :btree
  add_index "fallacy_translations", ["fallacy_sample_id"], name: "index_fallacy_translations_on_fallacy_sample_id", using: :btree
  add_index "fallacy_translations", ["language"], name: "index_fallacy_translations_on_language", using: :btree

  add_foreign_key "fallacy_samples", "fallacies"
  add_foreign_key "fallacy_translations", "fallacies"
  add_foreign_key "fallacy_translations", "fallacy_samples"
end
