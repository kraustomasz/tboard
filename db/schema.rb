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

ActiveRecord::Schema.define(version: 20141026201209) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: true do |t|
    t.string   "version"
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "task_created"
    t.datetime "created"
    t.integer  "points"
    t.boolean  "best"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "brainly_user_id"
  end

  create_table "cache_dbs", force: true do |t|
    t.string   "key"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "language_versions", force: true do |t|
    t.string   "name"
    t.string   "task_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain"
  end

  create_table "samples", force: true do |t|
    t.string   "field1"
    t.text     "field2"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_places", force: true do |t|
    t.integer  "type"
    t.integer  "place"
    t.integer  "user_id"
    t.integer  "answers"
    t.integer  "questions"
    t.integer  "points"
    t.integer  "bests"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "version"
    t.string   "nick"
    t.string   "profile_url"
    t.datetime "last_check"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
