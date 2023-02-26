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

ActiveRecord::Schema[7.0].define(version: 2023_02_26_125940) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "contact_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "realm_id"
    t.uuid "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_connections_on_contact_id"
    t.index ["organization_id"], name: "index_contact_connections_on_organization_id"
    t.index ["realm_id", "contact_id"], name: "index_contact_connections_on_realm_id_and_contact_id", unique: true
    t.index ["realm_id"], name: "index_contact_connections_on_realm_id"
  end

  create_table "contact_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "position_id"
    t.uuid "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_contact_memberships_on_contact_id"
    t.index ["organization_id"], name: "index_contact_memberships_on_organization_id"
    t.index ["position_id", "contact_id"], name: "index_contact_memberships_on_position_id_and_contact_id", unique: true
    t.index ["position_id"], name: "index_contact_memberships_on_position_id"
  end

  create_table "contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "first_name"
    t.string "last_name"
    t.text "emails", default: [], array: true
    t.text "phone_numbers", default: [], array: true
    t.string "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_contacts_on_organization_id"
    t.index ["remote_id"], name: "index_contacts_on_remote_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "position_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "realm_id"
    t.uuid "position_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_position_connections_on_organization_id"
    t.index ["position_id", "realm_id"], name: "index_position_connections_on_position_id_and_realm_id", unique: true
    t.index ["position_id"], name: "index_position_connections_on_position_id"
    t.index ["realm_id"], name: "index_position_connections_on_realm_id"
  end

  create_table "positions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "ancestry"
    t.string "title", null: false
    t.string "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_positions_on_ancestry"
    t.index ["organization_id"], name: "index_positions_on_organization_id"
    t.index ["remote_id"], name: "index_positions_on_remote_id"
  end

  create_table "realms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "remote_id"
    t.string "color"
    t.string "bg_color"
    t.string "slug"
    t.uuid "organization_id"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_realms_on_ancestry"
    t.index ["organization_id"], name: "index_realms_on_organization_id"
    t.index ["remote_id"], name: "index_realms_on_remote_id"
  end

  add_foreign_key "contact_connections", "contacts", on_delete: :cascade
  add_foreign_key "contact_connections", "organizations", on_delete: :cascade
  add_foreign_key "contact_connections", "realms", on_delete: :cascade
  add_foreign_key "contact_memberships", "contacts", on_delete: :cascade
  add_foreign_key "contact_memberships", "organizations", on_delete: :cascade
  add_foreign_key "contact_memberships", "positions", on_delete: :cascade
  add_foreign_key "contacts", "organizations", on_delete: :cascade
  add_foreign_key "position_connections", "organizations", on_delete: :cascade
  add_foreign_key "position_connections", "positions", on_delete: :cascade
  add_foreign_key "position_connections", "realms", on_delete: :cascade
  add_foreign_key "positions", "organizations", on_delete: :cascade
  add_foreign_key "realms", "organizations", on_delete: :cascade
end
