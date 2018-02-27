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

ActiveRecord::Schema.define(version: 20180227173242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "actuals", force: :cascade do |t|
    t.bigint "farm_id", null: false
    t.datetime "timestamp", null: false
    t.float "actual_mw", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_actuals_on_farm_id"
  end

  create_table "farm_providers", force: :cascade do |t|
    t.string "name", null: false
    t.string "label", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label"], name: "index_farm_providers_on_label", unique: true
    t.index ["name"], name: "index_farm_providers_on_name", unique: true
  end

  create_table "farms", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "farm_provider_id", null: false
    t.string "farm_provider_ref"
    t.float "lat", null: false
    t.float "lng", null: false
    t.float "capacity_mw"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_provider_id"], name: "index_farms_on_farm_provider_id"
    t.index ["farm_provider_ref", "farm_provider_id"], name: "index_farms_on_farm_provider_ref_and_farm_provider_id", unique: true
  end

  create_table "forecast_providers", force: :cascade do |t|
    t.string "name", null: false
    t.string "label", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label"], name: "index_forecast_providers_on_label", unique: true
    t.index ["name"], name: "index_forecast_providers_on_name", unique: true
  end

  create_table "forecast_types", force: :cascade do |t|
    t.string "name", null: false
    t.string "label", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["label"], name: "index_forecast_types_on_label", unique: true
    t.index ["name"], name: "index_forecast_types_on_name", unique: true
  end

  create_table "forecasts", force: :cascade do |t|
    t.bigint "farm_id", null: false
    t.bigint "forecast_type_id", null: false
    t.bigint "forecast_provider_id", null: false
    t.string "forecast_provider_forecast_ref"
    t.datetime "generate_at", null: false
    t.datetime "begins_at", null: false
    t.integer "horizon_minutes", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["farm_id"], name: "index_forecasts_on_farm_id"
    t.index ["forecast_provider_forecast_ref", "forecast_provider_id"], name: "forecast_provider_idx", unique: true
    t.index ["forecast_provider_id"], name: "index_forecasts_on_forecast_provider_id"
    t.index ["forecast_type_id"], name: "index_forecasts_on_forecast_type_id"
  end

  add_foreign_key "actuals", "farms"
  add_foreign_key "farms", "farm_providers"
  add_foreign_key "forecasts", "farms"
  add_foreign_key "forecasts", "forecast_providers"
  add_foreign_key "forecasts", "forecast_types"
end
