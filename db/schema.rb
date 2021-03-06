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

ActiveRecord::Schema.define(version: 20160804042448) do

  create_table "blood_sugar_maps", force: :cascade do |t|
    t.date     "tracked_day"
    t.text     "comment"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "consumed_foods", force: :cascade do |t|
    t.time     "scheduled_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "food_id"
    t.integer  "blood_sugar_map_id"
  end

  add_index "consumed_foods", ["blood_sugar_map_id"], name: "index_consumed_foods_on_blood_sugar_map_id"
  add_index "consumed_foods", ["food_id"], name: "index_consumed_foods_on_food_id"

  create_table "exercises", force: :cascade do |t|
    t.string   "name"
    t.integer  "exercise_index"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "foods", force: :cascade do |t|
    t.string   "name"
    t.integer  "glycemic_index"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "performed_exercises", force: :cascade do |t|
    t.time     "scheduled_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "exercise_id"
    t.integer  "blood_sugar_map_id"
  end

  add_index "performed_exercises", ["blood_sugar_map_id"], name: "index_performed_exercises_on_blood_sugar_map_id"
  add_index "performed_exercises", ["exercise_id"], name: "index_performed_exercises_on_exercise_id"

end
