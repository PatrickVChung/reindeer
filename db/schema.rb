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

ActiveRecord::Schema[7.1].define(version: 2024_11_14_181449) do
  create_schema "source"
  create_schema "target"
  create_schema "transform"

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "advisors", force: :cascade do |t|
    t.string "advisor_type"
    t.string "name"
    t.string "email"
    t.string "status"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "title"
    t.string "specialty"
  end

  create_table "artifacts", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_artifacts_on_user_id"
  end

  create_table "cohorts", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "permission_group_id"
    t.string "title"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["permission_group_id"], name: "index_cohorts_on_permission_group_id"
    t.index ["user_id"], name: "index_cohorts_on_user_id"
  end

  create_table "critical_values", primary_key: ["alpha", "df"], force: :cascade do |t|
    t.integer "df", null: false
    t.decimal "t", null: false
    t.decimal "alpha", default: "0.05", null: false
    t.check_constraint "df >= 1", name: "critical_values_df_check"
  end

  create_table "dashboard_widgets", id: :serial, force: :cascade do |t|
    t.integer "dashboard_id"
    t.integer "position"
    t.integer "sizex"
    t.integer "sizey"
    t.boolean "resizeable", default: true
    t.text "widget_type"
    t.integer "widget_id"
    t.string "widget_title", limit: 255
  end

  create_table "dashboards", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.text "theme"
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "data_migrations", id: :serial, force: :cascade do |t|
    t.text "version", null: false
  end

  create_table "events", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "start_date", precision: nil
    t.datetime "end_date", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.integer "advisor_id"
    t.index ["advisor_id", "id"], name: "index_events_on_advisor_id_and_id", unique: true
    t.index ["user_id", "id"], name: "index_events_on_user_id_and_id"
  end

  create_table "goals", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "g_status"
    t.string "competency_tag"
    t.datetime "target_date", precision: nil
    t.integer "user_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "medhub_period_ids", id: false, force: :cascade do |t|
    t.integer "courseID"
    t.integer "periodID"
    t.date "start_date"
    t.date "end_date"
    t.index ["courseID", "periodID"], name: "medhub_period_ids_idx"
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.string "subject", array: true
    t.datetime "date", precision: nil
    t.string "location"
    t.string "m_status"
    t.text "notes"
    t.integer "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "advisor_type"
    t.integer "advisor_id"
    t.integer "event_id"
    t.string "advice_category"
    t.text "advisor_discussed", default: [], array: true
    t.text "advisor_outcomes", default: [], array: true
    t.string "academic_discussed_other"
    t.string "academic_outcomes_other"
    t.string "career_discussed_other"
    t.string "career_outcomes_other"
    t.text "advisor_notes"
    t.text "study_resources", default: [], array: true
    t.string "study_resources_other"
    t.json "nbme_form"
    t.json "uworld_info"
    t.json "qbank_info"
    t.boolean "graduated_student"
    t.index ["advisor_id", "id"], name: "index_meetings_on_advisor_id_and_id", unique: true
    t.index ["event_id", "id"], name: "index_meetings_on_event_id_and_id", unique: true
    t.index ["user_id"], name: "index_meetings_on_user_id"
  end

  create_table "meta_attribute_entities", id: :serial, force: :cascade do |t|
    t.text "entity_type", null: false
    t.text "meta_attribute_entity_group_group_name", null: false
    t.integer "edition"
    t.integer "version"
    t.date "start_date"
    t.date "stop_date"
    t.boolean "visible", default: true
    t.integer "reference_year"
    t.string "entity_type_fk", limit: 255
    t.index ["entity_type"], name: "ix_meta_attribute_entities", unique: true
  end

  create_table "meta_attribute_questions", id: :serial, force: :cascade do |t|
    t.text "meta_attribute_entity_entity_type", null: false
    t.text "category"
    t.text "attribute_name"
    t.text "description"
    t.text "original_text"
    t.text "data_type"
    t.text "options_hash"
    t.boolean "continuous"
    t.boolean "optional"
    t.boolean "visible", default: true
    t.text "short_name"
  end

  create_table "meta_attribute_statistics", primary_key: "meta_attribute_statistic_id", id: :bigint, default: nil, force: :cascade do |t|
    t.string "subset_id"
    t.string "entity_schema"
    t.string "entity_name"
    t.bigint "attribute_index"
    t.string "attribute_name"
    t.string "attribute_description"
    t.string "attribute_data_type"
    t.decimal "count"
    t.decimal "n"
    t.decimal "n_percent", precision: 5, scale: 2
    t.decimal "mean"
    t.decimal "stddev"
    t.decimal "min"
    t.decimal "max"
    t.decimal "subset_count"
    t.decimal "subset_n"
    t.decimal "subset_n_percent", precision: 5, scale: 2
    t.decimal "subset_mean"
    t.decimal "subset_stddev"
    t.decimal "subset_min"
    t.decimal "subset_max"
    t.decimal "ci_lower"
    t.decimal "ci_upper"
    t.decimal "subset_ci_lower"
    t.decimal "subset_ci_upper"
    t.boolean "is_continuous", default: false, null: false
    t.index ["subset_id", "entity_schema", "entity_name", "attribute_name"], name: "ix_meta_attribute_statistics", unique: true
  end

  create_table "meta_attribute_values", primary_key: "meta_attribute_value_id", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "meta_attribute_statistic_id"
    t.string "subset_id"
    t.string "entity_schema"
    t.string "entity_name"
    t.string "attribute_name"
    t.decimal "value"
    t.string "value_description"
    t.decimal "count"
    t.decimal "subset_count"
    t.index ["meta_attribute_statistic_id"], name: "ix_meta_attribute_statistic_id"
    t.index ["subset_id", "entity_schema", "entity_name", "attribute_name", "value"], name: "ix_meta_attribute_values", unique: true
  end

  create_table "meta_attribute_values", primary_key: "meta_attribute_value_id", id: :bigint, default: nil, force: :cascade do |t|
    t.bigint "meta_attribute_statistic_id"
    t.string "subset_id"
    t.string "entity_schema"
    t.string "entity_name"
    t.string "attribute_name"
    t.decimal "value"
    t.string "value_description"
    t.decimal "count"
    t.decimal "subset_count"
    t.index ["meta_attribute_statistic_id"], name: "ix_meta_attribute_statistic_id"
    t.index ["subset_id", "entity_schema", "entity_name", "attribute_name", "value"], name: "ix_meta_attribute_values", unique: true
  end

  create_table "permission_groups", id: :serial, force: :cascade do |t|
    t.text "title", null: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.text "pinned_survey_group_titles"
  end

  create_table "permission_ls_group_filters", id: :serial, force: :cascade do |t|
    t.integer "permission_ls_group_id", null: false
    t.integer "lime_question_qid"
    t.text "ident_type"
    t.text "restricted_val"
    t.boolean "filter_all", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["permission_ls_group_id", "lime_question_qid"], name: "uniq_qid_by_group", unique: true
  end

  create_table "permission_ls_groups", id: :serial, force: :cascade do |t|
    t.integer "lime_survey_sid", null: false
    t.integer "permission_group_id", null: false
    t.boolean "enabled", default: false
    t.boolean "view_raw", default: false
    t.boolean "view_all", default: false
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.index ["lime_survey_sid", "permission_group_id"], name: "uniq_sid_by_group", unique: true
  end

  create_table "role_aggregates", id: :serial, force: :cascade do |t|
    t.string "pk_fieldname", limit: 255
    t.integer "lime_survey_sid"
    t.text "agg_fieldname"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.string "pk_title_fieldname", limit: 255
    t.string "view_type", limit: 255
    t.string "pk_label", limit: 255
    t.string "agg_label", limit: 255
    t.string "agg_title_fieldname", limit: 255
    t.string "default_view", limit: 255
  end

  create_table "rooms", id: :serial, force: :cascade do |t|
    t.string "identifier"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "discussable_id"
    t.string "discussable_type"
  end


  create_table "user_externals", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "ident", limit: 255
    t.string "ident_type", limit: 255
    t.boolean "use_email", default: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.integer "sign_in_count", default: 0
    t.datetime "current_sign_in_at", precision: nil
    t.datetime "last_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "p4_program_id"
    t.text "roles"
    t.string "full_name", limit: 255
    t.string "username", limit: 255
    t.datetime "locked_at", precision: nil
    t.boolean "is_ldap", default: false
    t.integer "permission_group_id"
    t.integer "cohort_id"
    t.string "ls_list_state", default: "dirty"
    t.string "coaching_type"
    t.integer "prev_permission_group_id"
    t.string "spec_program"
    t.string "sid"
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.boolean "subscribed", default: false, null: false
    t.date "matriculated_date"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sid"], name: "index_users_on_sid", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "version_notes", id: :serial, force: :cascade do |t|
    t.text "note"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "versions", id: :serial, force: :cascade do |t|
    t.string "item_type", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "event", limit: 255, null: false
    t.string "whodunnit", limit: 255
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.integer "version_note_id"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["version_note_id"], name: "index_versions_on_version_note_id"
  end

  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "artifacts", "users"
  add_foreign_key "cohorts", "users"
end
