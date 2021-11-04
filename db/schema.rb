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

ActiveRecord::Schema.define(version: 2021_11_04_103158) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "explorations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.uuid "transaction_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["planet_id"], name: "index_explorations_on_planet_id"
  end

  create_table "gameworlds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "minings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.integer "amount_mined"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "resource_id", null: false
    t.integer "amount_requested"
    t.index ["planet_id"], name: "index_minings_on_planet_id"
    t.index ["resource_id"], name: "index_minings_on_resource_id"
  end

  create_table "planets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "movement_difficulty"
    t.integer "recharge_multiplicator"
    t.integer "planet_type", default: 0
    t.datetime "taken_at"
    t.uuid "gameworld_id", null: false
    t.integer "x"
    t.integer "y"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["gameworld_id"], name: "index_planets_on_gameworld_id"
  end

  create_table "planets_neighbours", id: false, force: :cascade do |t|
    t.uuid "planet_id"
    t.uuid "neighbour_id"
    t.index ["planet_id", "neighbour_id"], name: "index_planets_neighbours_on_planet_id_and_neighbour_id", unique: true
  end

  create_table "replenishments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.integer "amount_replenished"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "resource_id", null: false
    t.index ["planet_id"], name: "index_replenishments_on_planet_id"
    t.index ["resource_id"], name: "index_replenishments_on_resource_id"
  end

  create_table "resource_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "difficulty", default: 0
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "resources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.uuid "resource_type_id", null: false
    t.integer "max_amount"
    t.integer "current_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["planet_id", "resource_type_id"], name: "index_resources_on_planet_id_and_resource_type_id", unique: true
    t.index ["planet_id"], name: "index_resources_on_planet_id"
    t.index ["resource_type_id"], name: "index_resources_on_resource_type_id"
  end

  create_table "spacestation_creations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["planet_id"], name: "index_spacestation_creations_on_planet_id"
  end

  create_table "spawn_creations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["planet_id"], name: "index_spawn_creations_on_planet_id"
  end

  add_foreign_key "explorations", "planets"
  add_foreign_key "minings", "planets"
  add_foreign_key "minings", "resources"
  add_foreign_key "planets", "gameworlds"
  add_foreign_key "replenishments", "planets"
  add_foreign_key "replenishments", "resources"
  add_foreign_key "resources", "planets"
  add_foreign_key "resources", "resource_types"
  add_foreign_key "spacestation_creations", "planets"
  add_foreign_key "spawn_creations", "planets"
end
