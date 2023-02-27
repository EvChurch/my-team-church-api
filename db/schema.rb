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

ActiveRecord::Schema[7.0].define(version: 2023_02_27_085739) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "title", null: false
    t.string "slug", null: false
    t.string "first_name"
    t.string "last_name"
    t.text "emails", default: [], array: true
    t.text "phone_numbers", default: [], array: true
    t.string "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "slug"], name: "index_contacts_on_organization_id_and_slug", unique: true
    t.index ["organization_id"], name: "index_contacts_on_organization_id"
    t.index ["remote_id"], name: "index_contacts_on_remote_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.string "fluro_api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_organizations_on_slug", unique: true
  end

  create_table "realm_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "subject_type"
    t.uuid "subject_id"
    t.uuid "realm_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_realm_connections_on_organization_id"
    t.index ["realm_id"], name: "index_realm_connections_on_realm_id"
    t.index ["subject_type", "subject_id"], name: "index_realm_connections_on_subject"
  end

  create_table "realms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.string "remote_id"
    t.string "color"
    t.string "bg_color"
    t.uuid "organization_id"
    t.string "ancestry"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_realms_on_ancestry"
    t.index ["organization_id", "slug"], name: "index_realms_on_organization_id_and_slug", unique: true
    t.index ["organization_id"], name: "index_realms_on_organization_id"
    t.index ["remote_id"], name: "index_realms_on_remote_id"
  end

  create_table "team_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id", null: false
    t.uuid "contact_id", null: false
    t.uuid "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contact_id"], name: "index_team_memberships_on_contact_id"
    t.index ["organization_id"], name: "index_team_memberships_on_organization_id"
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
  end

  create_table "teams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.string "ancestry"
    t.string "title", null: false
    t.string "slug", null: false
    t.string "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ancestry"], name: "index_teams_on_ancestry"
    t.index ["organization_id", "slug"], name: "index_teams_on_organization_id_and_slug", unique: true
    t.index ["organization_id"], name: "index_teams_on_organization_id"
    t.index ["remote_id"], name: "index_teams_on_remote_id"
  end

  add_foreign_key "contacts", "organizations", on_delete: :cascade
  add_foreign_key "realm_connections", "organizations", on_delete: :cascade
  add_foreign_key "realm_connections", "realms", on_delete: :cascade
  add_foreign_key "realms", "organizations", on_delete: :cascade
  add_foreign_key "team_memberships", "contacts", on_delete: :cascade
  add_foreign_key "team_memberships", "organizations", on_delete: :cascade
  add_foreign_key "team_memberships", "teams", on_delete: :cascade
  add_foreign_key "teams", "organizations", on_delete: :cascade
end
