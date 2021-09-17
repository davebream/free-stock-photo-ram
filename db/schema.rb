# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_09_17_133614) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "event_store_events", id: :serial, force: :cascade do |t|
    t.uuid "event_id", null: false
    t.string "event_type", null: false
    t.binary "metadata"
    t.binary "data", null: false
    t.datetime "created_at", null: false
    t.datetime "valid_at"
    t.index ["created_at"], name: "index_event_store_events_on_created_at"
    t.index ["event_id"], name: "index_event_store_events_on_event_id", unique: true
    t.index ["event_type"], name: "index_event_store_events_on_event_type"
    t.index ["valid_at"], name: "index_event_store_events_on_valid_at"
  end

  create_table "event_store_events_in_streams", id: :serial, force: :cascade do |t|
    t.string "stream", null: false
    t.integer "position"
    t.uuid "event_id", null: false
    t.datetime "created_at", null: false
    t.index ["created_at"], name: "index_event_store_events_in_streams_on_created_at"
    t.index ["stream", "event_id"], name: "index_event_store_events_in_streams_on_stream_and_event_id", unique: true
    t.index ["stream", "position"], name: "index_event_store_events_in_streams_on_stream_and_position", unique: true
  end

  create_table "read_model_media", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "status"
    t.string "copyright"
    t.datetime "publish_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "read_model_reviewing_photos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "filename"
    t.string "status"
    t.string "copyright"
    t.datetime "uploaded_at"
    t.datetime "publish_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "read_model_tagging_photos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "filename"
    t.datetime "last_tagging_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "read_model_tagging_tags", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "photo_id"
    t.string "name", null: false
    t.string "source", null: false
    t.string "provider"
    t.datetime "added_at"
    t.index ["photo_id"], name: "index_read_model_tagging_tags_on_photo_id"
  end

  create_table "read_model_uploads_files", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "filename"
    t.string "path"
    t.bigint "width"
    t.bigint "height"
    t.bigint "average_color_red"
    t.bigint "average_color_green"
    t.bigint "average_color_blue"
    t.datetime "uploaded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "read_model_tagging_tags", "read_model_tagging_photos", column: "photo_id"
end
