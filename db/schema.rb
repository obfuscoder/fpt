# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_12_26_171346) do

  create_table "flights", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "theater"
    t.string "airframe"
    t.datetime "start"
    t.integer "duration"
    t.string "callsign"
    t.integer "callsign_number"
    t.integer "slots"
    t.string "mission"
    t.string "task"
    t.integer "group_id"
    t.integer "laser"
    t.integer "tacan_channel"
    t.string "tacan_polarization"
    t.decimal "frequency"
    t.text "notes"
    t.string "loadout"
    t.string "start_airbase"
    t.string "land_airbase"
    t.string "divert_airbase"
    t.string "departure"
    t.string "recovery"
    t.string "flights"
    t.string "ao"
    t.string "divert"
    t.string "support"
    t.string "radio1"
    t.string "radio2"
    t.string "radio3"
    t.string "radio4"
  end

  create_table "pilots", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "flight_id", null: false
    t.integer "number"
    t.string "name"
    t.index ["flight_id"], name: "index_pilots_on_flight_id"
  end

  create_table "waypoints", force: :cascade do |t|
    t.integer "flight_id", null: false
    t.integer "number"
    t.string "name"
    t.string "position"
    t.string "altitude"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "waypoints"
    t.time "tot"
    t.index ["flight_id"], name: "index_waypoints_on_flight_id"
  end

  add_foreign_key "pilots", "flights"
  add_foreign_key "waypoints", "flights"
end
