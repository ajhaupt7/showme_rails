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

ActiveRecord::Schema.define(version: 20151109184335) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artists", force: :cascade do |t|
    t.string   "name"
    t.string   "song_preview"
    t.string   "image_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "artists_events", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "event_id"
  end

  create_table "cities", force: :cascade do |t|
    t.string   "city"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "city_dates", force: :cascade do |t|
    t.string   "city"
    t.string   "state"
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "city_dates_events", force: :cascade do |t|
    t.integer "city_date_id"
    t.integer "event_id"
  end

  create_table "events", force: :cascade do |t|
    t.datetime "datetime"
    t.string   "ticket_url"
    t.string   "venue_name"
    t.float    "venue_lat"
    t.float    "venue_long"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stored_dates", force: :cascade do |t|
    t.date     "date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
