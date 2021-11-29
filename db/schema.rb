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

ActiveRecord::Schema.define(version: 2021_11_29_112732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "explorations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.uuid "transaction_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.serial "version"
    t.index ["planet_id"], name: "index_explorations_on_planet_id"
  end

  create_table "gameworlds", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "minings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.integer "amount_mined"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "resource_id", null: false
    t.integer "amount_requested"
    t.serial "version"
    t.uuid "transaction_id"
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
    t.datetime "deleted_at"
    t.index ["gameworld_id", "x", "y"], name: "index_planets_on_gameworld_id_and_x_and_y"
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
    t.serial "version"
    t.uuid "transaction_id"
    t.index ["planet_id"], name: "index_replenishments_on_planet_id"
    t.index ["resource_id"], name: "index_replenishments_on_resource_id"
  end

  create_table "resources", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.integer "max_amount"
    t.integer "current_amount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "resource_type", default: 0
    t.index ["planet_id", "resource_type"], name: "index_resources_on_planet_id_and_resource_type", unique: true
    t.index ["planet_id"], name: "index_resources_on_planet_id"
  end

  create_table "spacestation_creations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.serial "version"
    t.uuid "transaction_id"
    t.index ["planet_id"], name: "index_spacestation_creations_on_planet_id"
  end

  create_table "spawn_creations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "planet_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.serial "version"
    t.uuid "transaction_id"
    t.index ["planet_id"], name: "index_spawn_creations_on_planet_id"
  end

  add_foreign_key "explorations", "planets"
  add_foreign_key "minings", "planets"
  add_foreign_key "minings", "resources"
  add_foreign_key "planets", "gameworlds"
  add_foreign_key "replenishments", "planets"
  add_foreign_key "replenishments", "resources"
  add_foreign_key "resources", "planets"
  add_foreign_key "spacestation_creations", "planets"
  add_foreign_key "spawn_creations", "planets"
end
