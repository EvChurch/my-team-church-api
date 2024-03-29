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

ActiveRecord::Schema[7.0].define(version: 2023_05_14_124132) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "slug", null: false
    t.string "status", default: "active"
    t.string "title", null: false
    t.string "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["remote_id"], name: "index_accounts_on_remote_id", unique: true
    t.index ["slug"], name: "index_accounts_on_slug", unique: true
  end

  create_table "applications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "definition", null: false
    t.string "slug", null: false
    t.string "status", default: "active"
    t.string "title", null: false
    t.string "remote_id"
    t.string "api_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_applications_on_account_id", unique: true
  end

  create_table "contact_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "contact_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_contact_connections_on_account_id"
    t.index ["contact_id"], name: "index_contact_connections_on_contact_id"
    t.index ["user_id", "contact_id"], name: "index_contact_connections_on_user_id_and_contact_id", unique: true
    t.index ["user_id"], name: "index_contact_connections_on_user_id"
  end

  create_table "contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "definition", null: false
    t.string "slug", null: false
    t.string "status", default: "active"
    t.string "title", null: false
    t.string "remote_id"
    t.string "first_name"
    t.string "last_name"
    t.text "emails", default: [], array: true
    t.text "phone_numbers", default: [], array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.index ["account_id", "remote_id"], name: "index_contacts_on_account_id_and_remote_id", unique: true
    t.index ["account_id", "slug"], name: "index_contacts_on_account_id_and_slug", unique: true
    t.index ["account_id"], name: "index_contacts_on_account_id"
  end

  create_table "early_accesses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name", null: false
    t.string "email_address", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email_address"], name: "index_early_accesses_on_email_address", unique: true
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

  create_table "objective_activities", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "objective_id", null: false
    t.uuid "result_id"
    t.uuid "contact_id", null: false
    t.string "kind", default: "progress_update", null: false
    t.decimal "current_value"
    t.string "progress"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_objective_activities_on_account_id"
    t.index ["contact_id"], name: "index_objective_activities_on_contact_id"
    t.index ["objective_id"], name: "index_objective_activities_on_objective_id"
    t.index ["result_id"], name: "index_objective_activities_on_result_id"
  end

  create_table "objective_results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "objective_id", null: false
    t.string "title", null: false
    t.string "description"
    t.uuid "contact_id", null: false
    t.string "measurement", default: "numerical", null: false
    t.string "kind", default: "key_result", null: false
    t.string "progress", default: "no_status", null: false
    t.decimal "start_value", default: "0.0", null: false
    t.decimal "current_value"
    t.decimal "target_value", default: "100.0", null: false
    t.date "start_at"
    t.date "due_at"
    t.string "status", default: "draft", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "percentage", default: 0, null: false
    t.index ["account_id"], name: "index_objective_results_on_account_id"
    t.index ["contact_id"], name: "index_objective_results_on_contact_id"
    t.index ["objective_id"], name: "index_objective_results_on_objective_id"
  end

  create_table "objectives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "team_id", null: false
    t.uuid "contact_id", null: false
    t.string "title", null: false
    t.string "description"
    t.string "status", default: "draft", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "due_at", default: -> { "now()" }, null: false
    t.string "progress", default: "no_status", null: false
    t.decimal "percentage", default: "0.0", null: false
    t.index ["account_id"], name: "index_objectives_on_account_id"
    t.index ["contact_id"], name: "index_objectives_on_contact_id"
    t.index ["team_id"], name: "index_objectives_on_team_id"
  end

  create_table "realm_connections", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "subject_type", null: false
    t.uuid "subject_id", null: false
    t.uuid "realm_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_realm_connections_on_account_id"
    t.index ["realm_id"], name: "index_realm_connections_on_realm_id"
    t.index ["subject_id", "subject_type", "realm_id"], name: "index_realm_connections_on_subject_and_realm_id", unique: true
    t.index ["subject_type", "subject_id"], name: "index_realm_connections_on_subject"
  end

  create_table "realms", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "ancestry"
    t.string "definition", null: false
    t.string "slug", null: false
    t.string "status", default: "active"
    t.string "title", null: false
    t.string "remote_id"
    t.string "color"
    t.string "bg_color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "remote_id"], name: "index_realms_on_account_id_and_remote_id", unique: true
    t.index ["account_id", "slug"], name: "index_realms_on_account_id_and_slug", unique: true
    t.index ["account_id"], name: "index_realms_on_account_id"
    t.index ["ancestry"], name: "index_realms_on_ancestry"
  end

  create_table "team_assignments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "position_id", null: false
    t.uuid "contact_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "progress", default: "no_status", null: false
    t.index ["account_id"], name: "index_team_assignments_on_account_id"
    t.index ["contact_id"], name: "index_team_assignments_on_contact_id"
    t.index ["position_id", "contact_id"], name: "index_team_assignments_on_position_id_and_contact_id", unique: true
    t.index ["position_id"], name: "index_team_assignments_on_position_id"
    t.index ["progress"], name: "index_team_assignments_on_progress"
  end

  create_table "team_memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "contact_id", null: false
    t.uuid "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_team_memberships_on_account_id"
    t.index ["contact_id", "team_id"], name: "index_team_memberships_on_contact_id_and_team_id", unique: true
    t.index ["contact_id"], name: "index_team_memberships_on_contact_id"
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
  end

  create_table "team_positions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.uuid "team_id", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.string "remote_id"
    t.boolean "exclude", default: false, null: false
    t.boolean "reporter", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assignments_count", default: 0, null: false
    t.integer "required_assignments_count", default: 0, null: false
    t.string "progress", default: "no_status", null: false
    t.index ["account_id", "team_id", "remote_id"], name: "index_team_positions_on_account_id_and_team_id_and_remote_id", unique: true
    t.index ["account_id", "team_id", "slug"], name: "index_team_positions_on_account_id_and_team_id_and_slug", unique: true
    t.index ["account_id"], name: "index_team_positions_on_account_id"
    t.index ["progress"], name: "index_team_positions_on_progress"
    t.index ["team_id"], name: "index_team_positions_on_team_id"
  end

  create_table "teams", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "ancestry"
    t.string "definition", null: false
    t.string "slug", null: false
    t.string "status", default: "active"
    t.string "title", null: false
    t.string "remote_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "visible_members"
    t.integer "percentage", default: 0, null: false
    t.string "progress", default: "no_status", null: false
    t.index ["account_id", "remote_id"], name: "index_teams_on_account_id_and_remote_id", unique: true
    t.index ["account_id", "slug"], name: "index_teams_on_account_id_and_slug", unique: true
    t.index ["account_id"], name: "index_teams_on_account_id"
    t.index ["ancestry"], name: "index_teams_on_ancestry"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "account_id", null: false
    t.string "title", null: false
    t.string "slug", null: false
    t.string "remote_id"
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "avatar"
    t.index ["account_id", "remote_id"], name: "index_users_on_account_id_and_remote_id", unique: true
    t.index ["account_id", "slug"], name: "index_users_on_account_id_and_slug", unique: true
    t.index ["account_id"], name: "index_users_on_account_id"
  end

  add_foreign_key "applications", "accounts", on_delete: :cascade
  add_foreign_key "contact_connections", "accounts", on_delete: :cascade
  add_foreign_key "contact_connections", "contacts", on_delete: :cascade
  add_foreign_key "contact_connections", "users", on_delete: :cascade
  add_foreign_key "contacts", "accounts", on_delete: :cascade
  add_foreign_key "objective_activities", "accounts", on_delete: :cascade
  add_foreign_key "objective_activities", "contacts", on_delete: :cascade
  add_foreign_key "objective_activities", "objective_results", column: "result_id", on_delete: :cascade
  add_foreign_key "objective_activities", "objectives", on_delete: :cascade
  add_foreign_key "objective_results", "accounts", on_delete: :cascade
  add_foreign_key "objective_results", "contacts", on_delete: :cascade
  add_foreign_key "objective_results", "objectives", on_delete: :cascade
  add_foreign_key "objectives", "accounts", on_delete: :cascade
  add_foreign_key "objectives", "contacts", on_delete: :cascade
  add_foreign_key "objectives", "teams", on_delete: :cascade
  add_foreign_key "realm_connections", "accounts", on_delete: :cascade
  add_foreign_key "realm_connections", "realms", on_delete: :cascade
  add_foreign_key "realms", "accounts", on_delete: :cascade
  add_foreign_key "team_assignments", "accounts", on_delete: :cascade
  add_foreign_key "team_assignments", "contacts", on_delete: :cascade
  add_foreign_key "team_assignments", "team_positions", column: "position_id", on_delete: :cascade
  add_foreign_key "team_memberships", "accounts", on_delete: :cascade
  add_foreign_key "team_memberships", "contacts", on_delete: :cascade
  add_foreign_key "team_memberships", "teams", on_delete: :cascade
  add_foreign_key "team_positions", "accounts", on_delete: :cascade
  add_foreign_key "team_positions", "teams", on_delete: :cascade
  add_foreign_key "teams", "accounts", on_delete: :cascade
  add_foreign_key "users", "accounts", on_delete: :cascade
end
