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

ActiveRecord::Schema[8.1].define(version: 2026_07_14_170605) do
  create_schema "source"
  create_schema "target"
  create_schema "transform"

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "uuid-ossp"

  create_table "public.active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "public.active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.string "content_type"
    t.datetime "created_at", precision: nil, null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "public.active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "public.advisors", force: :cascade do |t|
    t.string "advisor_type"
    t.text "brief_cv"
    t.datetime "created_at", precision: nil, null: false
    t.string "email"
    t.string "formal_name"
    t.string "name"
    t.string "specialty"
    t.string "status"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "public.artifacts", force: :cascade do |t|
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_artifacts_on_user_id"
  end

  create_table "public.badging_dates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "last_review_end_date"
    t.date "next_review_end_date"
    t.integer "permission_group_id"
    t.date "release_date"
    t.datetime "updated_at", null: false
  end

  create_table "public.chart_series", id: :serial, force: :cascade do |t|
    t.text "category_filter"
    t.integer "chart_id"
    t.datetime "created_at", precision: nil
    t.text "entity_filter"
    t.text "group_filter"
    t.text "question_filter"
    t.text "question_options_filter"
    t.datetime "updated_at", precision: nil
    t.index ["chart_id"], name: "index_chart_series_on_chart_id"
  end

  create_table "public.charts", id: :serial, force: :cascade do |t|
    t.text "aggregator_type"
    t.text "chart_type"
    t.text "cols"
    t.datetime "created_at", precision: nil
    t.text "output"
    t.text "rows"
    t.text "title"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.index ["user_id"], name: "index_charts_on_user_id"
  end

  create_table "public.cohorts", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "permission_group_id"
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["permission_group_id"], name: "index_cohorts_on_permission_group_id"
    t.index ["user_id"], name: "index_cohorts_on_user_id"
  end

  create_table "public.competencies", force: :cascade do |t|
    t.text "add_comm_on_perform"
    t.text "clinic_exp_comment"
    t.text "comm_prof_concerns"
    t.string "course_id"
    t.string "course_name"
    t.datetime "created_at", precision: nil, null: false
    t.string "email"
    t.date "end_date"
    t.string "environment"
    t.string "evaluator"
    t.text "feedback"
    t.string "final_grade"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.string "medhub_id"
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.text "mspe"
    t.text "overall_summ_comm_perf"
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.bigint "permission_group_id"
    t.integer "pppd1", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.text "prof_concerns"
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.date "start_date"
    t.string "student_uid"
    t.date "submit_date"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["permission_group_id"], name: "index_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_competencies_on_user_id"
  end

  create_table "public.content_slugs", id: :serial, force: :cascade do |t|
    t.text "content"
    t.boolean "public"
    t.boolean "resizeable", default: true
    t.integer "sizex"
    t.integer "sizey"
    t.integer "user_id"
  end

  create_table "public.course_schedules", force: :cascade do |t|
    t.string "block"
    t.string "comment"
    t.bigint "course_id"
    t.datetime "created_at", precision: nil
    t.date "end_date"
    t.integer "no_of_seats"
    t.date "start_date"
    t.datetime "updated_at", precision: nil
    t.integer "year"
    t.index ["course_id"], name: "index_course_schedules_on_course_id"
  end

  create_table "public.courses", force: :cascade do |t|
    t.string "admin_notes"
    t.boolean "available_through_the_lottery"
    t.text "competencies", default: [], array: true
    t.string "competency_note"
    t.string "content_type"
    t.boolean "continuity"
    t.string "course_coordinator"
    t.string "course_coordinator_email"
    t.string "course_director"
    t.string "course_director_email"
    t.string "course_name"
    t.string "course_number"
    t.string "course_purpose_statement"
    t.string "course_type"
    t.datetime "created_at", null: false
    t.decimal "credits"
    t.string "department"
    t.string "duration"
    t.string "enrollment_instructions"
    t.string "grading_method", default: "Pass/No Pass"
    t.integer "medhub_course_id"
    t.boolean "prerequisites"
    t.string "qualified_assessor"
    t.string "qualified_assessor_email"
    t.string "required_prerequisites"
    t.boolean "rural"
    t.string "site"
    t.string "special_notes"
    t.datetime "updated_at", null: false
    t.string "waive_notes"
    t.boolean "waive_prereq_requirements"
    t.integer "weekly_workload"
    t.index ["course_type", "course_number"], name: "index_courses_on_course_type_and_course_number"
  end

  create_table "public.cpxes", force: :cascade do |t|
    t.json "cpx_data"
    t.string "email"
    t.string "full_name"
    t.bigint "user_id"
    t.index ["email"], name: "index_cpxes_on_email", unique: true
    t.index ["user_id"], name: "index_cpxes_on_user_id"
  end

  create_table "public.csl_evals", force: :cascade do |t|
    t.integer "c1"
    t.integer "c2"
    t.integer "c3"
    t.integer "c4"
    t.integer "c5"
    t.integer "c6"
    t.integer "c7"
    t.integer "c8"
    t.integer "c9"
    t.string "cohorts"
    t.datetime "created_at", precision: nil, null: false
    t.string "csl_title"
    t.text "feedback"
    t.string "instructor"
    t.string "selected_student"
    t.date "submit_date"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_csl_evals_on_user_id"
  end

  create_table "public.csl_feedbacks", force: :cascade do |t|
    t.string "c1"
    t.string "c1_feedback"
    t.string "c2"
    t.string "c2_feedback"
    t.string "cohorts"
    t.datetime "created_at", precision: nil, null: false
    t.string "csl_title"
    t.text "feedback_improve"
    t.text "feedback_strength"
    t.string "instructor"
    t.string "response_id"
    t.string "selected_student"
    t.date "submit_date"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["response_id"], name: "index_csl_feedbacks_on_response_id", unique: true
    t.index ["user_id"], name: "index_csl_feedbacks_on_user_id"
  end

  create_table "public.dashboard_widgets", id: :serial, force: :cascade do |t|
    t.integer "dashboard_id"
    t.integer "position"
    t.boolean "resizeable", default: true
    t.integer "sizex"
    t.integer "sizey"
    t.integer "widget_id"
    t.string "widget_title", limit: 255
    t.text "widget_type"
  end

  create_table "public.dashboards", id: :serial, force: :cascade do |t|
    t.text "theme"
    t.integer "user_id"
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "public.data_migrations", id: :serial, force: :cascade do |t|
    t.text "version", null: false
  end

  create_table "public.eg_cohorts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "eg_email1"
    t.string "eg_email2"
    t.string "eg_full_name1"
    t.string "eg_full_name2"
    t.string "email"
    t.integer "permission_group_id"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_eg_cohorts_on_user_id"
  end

  create_table "public.eg_members", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.string "eg_type"
    t.string "email"
    t.string "full_name"
    t.datetime "updated_at", null: false
  end

  create_table "public.eg_reasons", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "reason"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "public.epa_masters", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.string "epa"
    t.datetime "expiration_date", precision: nil
    t.string "status"
    t.datetime "status_date", precision: nil
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["user_id", "epa"], name: "by_user_epas", unique: true
    t.index ["user_id"], name: "index_epa_masters_on_user_id"
  end

  create_table "public.epa_reviews", force: :cascade do |t|
    t.string "badge_decision1"
    t.string "badge_decision2"
    t.datetime "created_at", precision: nil, null: false
    t.string "epa"
    t.text "evidence1"
    t.text "evidence2"
    t.text "general_comments1"
    t.text "general_comments2"
    t.string "reason1"
    t.string "reason2"
    t.datetime "review_date1", precision: nil
    t.datetime "review_date2", precision: nil
    t.bigint "reviewable_id"
    t.string "reviewable_type"
    t.string "reviewer1"
    t.string "reviewer2"
    t.string "student_comments1"
    t.string "student_comments2"
    t.string "trust1"
    t.string "trust2"
    t.datetime "updated_at", precision: nil, null: false
    t.index ["epa", "id"], name: "by_epa_reviews", unique: true
    t.index ["reviewable_type", "reviewable_id"], name: "index_epa_reviews_on_reviewable_type_and_reviewable_id"
  end

  create_table "public.epas", force: :cascade do |t|
    t.string "assessor_email"
    t.string "assessor_name"
    t.boolean "attending_faculty"
    t.string "clinical_assessor"
    t.string "clinical_discipline"
    t.string "clinical_setting"
    t.datetime "created_at", precision: nil, null: false
    t.boolean "encounter_complex"
    t.string "epa"
    t.integer "involvement"
    t.string "meta_browser"
    t.string "meta_device"
    t.string "meta_os"
    t.string "meta_screen_size"
    t.string "more_independent"
    t.string "no_of_times_with_super"
    t.string "other_role"
    t.string "response_id"
    t.string "student_assessed"
    t.datetime "submit_date", precision: nil
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["response_id"], name: "index_epas_on_response_id"
    t.index ["user_id"], name: "index_epas_on_user_id"
  end

  create_table "public.events", force: :cascade do |t|
    t.integer "advisor_id"
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.datetime "end_date", precision: nil
    t.datetime "start_date", precision: nil
    t.string "title"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["advisor_id", "id"], name: "index_events_on_advisor_id_and_id", unique: true
    t.index ["user_id", "id"], name: "index_events_on_user_id_and_id"
  end

  create_table "public.fileupload_settings", force: :cascade do |t|
    t.string "code"
    t.datetime "created_at", null: false
    t.integer "permission_group_id"
    t.datetime "updated_at", null: false
    t.boolean "visible"
    t.index ["permission_group_id", "code"], name: "index_fileupload_settings_on_permission_group_id_and_code", unique: true
  end

  create_table "public.fom_exams", force: :cascade do |t|
    t.string "comp1_dropped_quiz"
    t.decimal "comp1_dropped_score"
    t.decimal "comp1_wk1"
    t.decimal "comp1_wk10"
    t.decimal "comp1_wk11"
    t.decimal "comp1_wk12"
    t.decimal "comp1_wk2"
    t.decimal "comp1_wk3"
    t.decimal "comp1_wk4"
    t.decimal "comp1_wk5"
    t.decimal "comp1_wk6"
    t.decimal "comp1_wk7"
    t.decimal "comp1_wk8"
    t.decimal "comp1_wk9"
    t.decimal "comp2a_hss1"
    t.decimal "comp2a_hss10"
    t.decimal "comp2a_hss11"
    t.decimal "comp2a_hss12"
    t.decimal "comp2a_hss13"
    t.decimal "comp2a_hss14"
    t.decimal "comp2a_hss15"
    t.decimal "comp2a_hss16"
    t.decimal "comp2a_hss17"
    t.decimal "comp2a_hss18"
    t.decimal "comp2a_hss19"
    t.decimal "comp2a_hss2"
    t.decimal "comp2a_hss20"
    t.decimal "comp2a_hss21"
    t.decimal "comp2a_hss22"
    t.decimal "comp2a_hss3"
    t.decimal "comp2a_hss4"
    t.decimal "comp2a_hss5"
    t.decimal "comp2a_hss6"
    t.decimal "comp2a_hss7"
    t.decimal "comp2a_hss8"
    t.decimal "comp2a_hss9"
    t.decimal "comp2a_hssavg"
    t.decimal "comp2b_bss1"
    t.decimal "comp2b_bss10"
    t.decimal "comp2b_bss11"
    t.decimal "comp2b_bss12"
    t.decimal "comp2b_bss2"
    t.decimal "comp2b_bss3"
    t.decimal "comp2b_bss4"
    t.decimal "comp2b_bss5"
    t.decimal "comp2b_bss6"
    t.decimal "comp2b_bss7"
    t.decimal "comp2b_bss8"
    t.decimal "comp2b_bss9"
    t.decimal "comp2b_bssavg"
    t.decimal "comp3_final1"
    t.decimal "comp3_final2"
    t.decimal "comp3_final3"
    t.decimal "comp4_nbme"
    t.decimal "comp5a_hss1"
    t.decimal "comp5a_hss2"
    t.decimal "comp5a_hss3"
    t.decimal "comp5a_hssavg"
    t.decimal "comp5b_bss1"
    t.decimal "comp5b_bss2"
    t.decimal "comp5b_bss3"
    t.decimal "comp5b_bss4"
    t.decimal "comp5b_bss5"
    t.decimal "comp5b_bssavg"
    t.decimal "comp6_mb"
    t.string "course_code"
    t.date "course_end_date"
    t.datetime "created_at", precision: nil, null: false
    t.integer "permission_group_id"
    t.datetime "submit_date", precision: nil
    t.decimal "summary_comp1"
    t.decimal "summary_comp2a"
    t.decimal "summary_comp2b"
    t.decimal "summary_comp3"
    t.decimal "summary_comp4"
    t.decimal "summary_comp5a"
    t.decimal "summary_comp5b"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["user_id", "permission_group_id", "course_code"], name: "by_user_permission_group_course_code", unique: true
    t.index ["user_id"], name: "index_fom_exams_on_user_id"
  end

  create_table "public.fom_labels", force: :cascade do |t|
    t.boolean "block_enabled"
    t.string "course_code"
    t.json "labels"
    t.integer "permission_group_id"
    t.index ["permission_group_id", "course_code"], name: "by_permission_group_course_code", unique: true
  end

  create_table "public.fom_remeds", force: :cascade do |t|
    t.string "acad_probation"
    t.string "areas_of_deficiency"
    t.string "block"
    t.string "component_desc"
    t.string "component_failed"
    t.datetime "created_at", null: false
    t.decimal "initial_test_result"
    t.integer "no_of_failures_to_date"
    t.string "notes"
    t.string "passed_failed"
    t.integer "prev_comp_failures"
    t.decimal "re_test_result"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id"], name: "index_fom_remeds_on_user_id"
  end

  create_table "public.formative_feedbacks", force: :cascade do |t|
    t.string "block_code"
    t.datetime "created_at", null: false
    t.string "csa_code"
    t.string "q1"
    t.string "q2"
    t.string "q3"
    t.string "q4"
    t.string "q5"
    t.string "q6"
    t.string "q7"
    t.string "q8"
    t.string "response_id"
    t.date "submit_date"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["response_id"], name: "index_formative_feedbacks_on_response_id"
    t.index ["user_id"], name: "index_formative_feedbacks_on_user_id"
  end

  create_table "public.goals", id: :serial, force: :cascade do |t|
    t.string "competency_tag"
    t.datetime "created_at", precision: nil, null: false
    t.text "description"
    t.string "g_status"
    t.string "name", null: false
    t.datetime "target_date", precision: nil
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id", null: false
    t.index ["user_id"], name: "index_goals_on_user_id"
  end

  create_table "public.ipe_courses", primary_key: "course_id", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "course_code", limit: 20, null: false
    t.string "course_name", limit: 100

    t.unique_constraint ["course_code"], name: "ipe_courses_course_code"
  end

  create_table "public.med18_competencies", force: :cascade do |t|
    t.text "add_comm_on_perform"
    t.text "clinic_exp_comment"
    t.text "comm_prof_concerns"
    t.string "course_id"
    t.string "course_name"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.string "email"
    t.date "end_date"
    t.string "environment"
    t.string "evaluator"
    t.text "feedback"
    t.string "final_grade"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.string "medhub_id"
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.text "mspe"
    t.text "overall_summ_comm_perf"
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.bigint "permission_group_id"
    t.integer "pppd1", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.text "prof_concerns"
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.date "start_date"
    t.string "student_uid"
    t.date "submit_date"
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.bigint "user_id"
    t.index ["permission_group_id"], name: "index_med18_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_med18_competencies_on_user_id"
  end

  create_table "public.med18_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"

    t.unique_constraint ["email"], name: "med18_mspe_email_key"
  end

  create_table "public.med19_competencies", force: :cascade do |t|
    t.text "add_comm_on_perform"
    t.text "clinic_exp_comment"
    t.text "comm_prof_concerns"
    t.string "course_id"
    t.string "course_name"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.string "email"
    t.date "end_date"
    t.string "environment"
    t.string "evaluator"
    t.text "feedback"
    t.string "final_grade"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.string "medhub_id"
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.text "mspe"
    t.text "overall_summ_comm_perf"
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.integer "permission_group_id"
    t.integer "pppd1", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.text "prof_concerns"
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.date "start_date"
    t.string "student_uid"
    t.date "submit_date"
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.bigint "user_id"
    t.index ["permission_group_id"], name: "index_med19_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_med19_competencies_on_user_id"
  end

  create_table "public.med19_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"

    t.unique_constraint ["email"], name: "med19_mspe_email_key"
  end

  create_table "public.med20_competencies", force: :cascade do |t|
    t.text "add_comm_on_perform"
    t.text "clinic_exp_comment"
    t.text "comm_prof_concerns"
    t.string "course_id"
    t.string "course_name"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.string "email"
    t.date "end_date"
    t.string "environment"
    t.string "evaluator"
    t.text "feedback"
    t.string "final_grade"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.string "medhub_id"
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.text "mspe"
    t.text "overall_summ_comm_perf"
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.integer "permission_group_id"
    t.integer "pppd1", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.text "prof_concerns"
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.date "start_date"
    t.string "student_uid"
    t.date "submit_date"
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.bigint "user_id"
    t.index ["permission_group_id"], name: "index_med20_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_med20_competencies_on_user_id"
  end

  create_table "public.med20_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"

    t.unique_constraint ["email"], name: "med20_mspe_email_key"
  end

  create_table "public.med21_competencies", force: :cascade do |t|
    t.text "add_comm_on_perform"
    t.text "clinic_exp_comment"
    t.text "comm_prof_concerns"
    t.string "course_id"
    t.string "course_name"
    t.datetime "created_at", precision: nil, default: -> { "now()" }, null: false
    t.string "email"
    t.date "end_date"
    t.string "environment"
    t.string "evaluator"
    t.text "feedback"
    t.string "final_grade"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.string "medhub_id"
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.text "mspe"
    t.text "overall_summ_comm_perf"
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.integer "permission_group_id"
    t.integer "pppd1", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.text "prof_concerns"
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.date "start_date"
    t.string "student_uid"
    t.date "submit_date"
    t.datetime "updated_at", precision: nil, default: -> { "now()" }, null: false
    t.bigint "user_id"
    t.index ["permission_group_id"], name: "index_med21_competencies_on_permission_group_id"
    t.index ["user_id"], name: "index_med21_competencies_on_user_id"
  end

  create_table "public.med21_fom_exams", force: :cascade do |t|
    t.string "comp1_dropped_quiz"
    t.decimal "comp1_dropped_score"
    t.decimal "comp1_wk1"
    t.decimal "comp1_wk10"
    t.decimal "comp1_wk11"
    t.decimal "comp1_wk12"
    t.decimal "comp1_wk2"
    t.decimal "comp1_wk3"
    t.decimal "comp1_wk4"
    t.decimal "comp1_wk5"
    t.decimal "comp1_wk6"
    t.decimal "comp1_wk7"
    t.decimal "comp1_wk8"
    t.decimal "comp1_wk9"
    t.decimal "comp2b_bss1"
    t.decimal "comp2b_bss10"
    t.decimal "comp2b_bss11"
    t.decimal "comp2b_bss12"
    t.decimal "comp2b_bss2"
    t.decimal "comp2b_bss3"
    t.decimal "comp2b_bss4"
    t.decimal "comp2b_bss5"
    t.decimal "comp2b_bss6"
    t.decimal "comp2b_bss7"
    t.decimal "comp2b_bss8"
    t.decimal "comp2b_bss9"
    t.decimal "comp3_final1"
    t.decimal "comp3_final2"
    t.decimal "comp3_final3"
    t.decimal "comp4_nbme"
    t.decimal "comp5a_hss1"
    t.decimal "comp5a_hss2"
    t.decimal "comp5a_hss3"
    t.decimal "comp5a_hss4"
    t.decimal "comp5a_hss5"
    t.decimal "comp5b_bss1"
    t.decimal "comp5b_bss2"
    t.decimal "comp5b_bss3"
    t.decimal "comp5b_bss4"
    t.decimal "comp5b_bss5"
    t.decimal "comp5b_bss6"
    t.decimal "comp5b_bss7"
    t.string "course_code"
    t.datetime "created_at", null: false
    t.integer "permission_group_id"
    t.datetime "submit_date", precision: nil
    t.decimal "summary_comp1"
    t.decimal "summary_comp2b"
    t.decimal "summary_comp3"
    t.decimal "summary_comp4"
    t.decimal "summary_comp5a"
    t.decimal "summary_comp5b"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id", "permission_group_id", "course_code"], name: "by_med21_user_permission_group_course_code", unique: true
  end

  create_table "public.med21_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"

    t.unique_constraint ["email"], name: "med21_mspe_email_key"
  end

  create_table "public.med22_fom_exams", force: :cascade do |t|
    t.string "comp1_dropped_quiz"
    t.decimal "comp1_dropped_score"
    t.decimal "comp1_wk1"
    t.decimal "comp1_wk10"
    t.decimal "comp1_wk11"
    t.decimal "comp1_wk12"
    t.decimal "comp1_wk2"
    t.decimal "comp1_wk3"
    t.decimal "comp1_wk4"
    t.decimal "comp1_wk5"
    t.decimal "comp1_wk6"
    t.decimal "comp1_wk7"
    t.decimal "comp1_wk8"
    t.decimal "comp1_wk9"
    t.decimal "comp2a_hss1"
    t.decimal "comp2a_hss2"
    t.decimal "comp2a_hss3"
    t.decimal "comp2a_hss4"
    t.decimal "comp2a_hss5"
    t.decimal "comp2a_hss6"
    t.decimal "comp2a_hss7"
    t.decimal "comp2a_hssavg"
    t.decimal "comp2b_bss1"
    t.decimal "comp2b_bss2"
    t.decimal "comp2b_bss3"
    t.decimal "comp2b_bss4"
    t.decimal "comp2b_bss5"
    t.decimal "comp2b_bss6"
    t.decimal "comp2b_bss7"
    t.decimal "comp2b_bss8"
    t.decimal "comp2b_bss9"
    t.decimal "comp2b_bssavg"
    t.decimal "comp3_final1"
    t.decimal "comp3_final2"
    t.decimal "comp3_final3"
    t.decimal "comp4_nbme"
    t.decimal "comp5a_hss1"
    t.decimal "comp5a_hss2"
    t.decimal "comp5a_hss3"
    t.decimal "comp5a_hss4"
    t.decimal "comp5a_hssavg"
    t.decimal "comp5b_bss1"
    t.decimal "comp5b_bss2"
    t.decimal "comp5b_bss3"
    t.decimal "comp5b_bss4"
    t.decimal "comp5b_bss5"
    t.decimal "comp5b_bssavg"
    t.string "course_code"
    t.datetime "created_at", null: false
    t.integer "permission_group_id"
    t.datetime "submit_date", precision: nil
    t.decimal "summary_comp1"
    t.decimal "summary_comp2a"
    t.decimal "summary_comp2b"
    t.decimal "summary_comp3"
    t.decimal "summary_comp4"
    t.decimal "summary_comp5a"
    t.decimal "summary_comp5b"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["user_id", "permission_group_id", "course_code"], name: "by_med22_user_permission_group_course_code", unique: true
  end

  create_table "public.med22_mspe_cces", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50

    t.unique_constraint ["email"], name: "med22_mspe_cces_email_key"
  end

  create_table "public.med22_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"

    t.unique_constraint ["email"], name: "med22_mspe_email_key"
  end

  create_table "public.med23_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_med23_mspes_on_user_id"
    t.unique_constraint ["email"], name: "med23_mspe_email_key"
  end

  create_table "public.med24_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_med24_mspes_on_user_id"
    t.unique_constraint ["email"], name: "med24_mspe_email_key"
  end

  create_table "public.med25_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_med25_mspes_on_user_id"
    t.unique_constraint ["email"], name: "med25_mspe_email_key"
  end

  create_table "public.med26_mspes", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "email", limit: 50, null: false
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_med26_mspes_on_user_id"
    t.unique_constraint ["email"], name: "med26_mspe_email_key"
  end

  create_table "public.med27_mspes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "full_name"
    t.integer "permission_group_id"
    t.string "sid"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_med27_mspes_on_user_id"
  end

  create_table "public.medhub_courses", force: :cascade do |t|
    t.string "course_code"
    t.integer "course_id"
    t.string "course_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_code"], name: "index_medhub_courses_on_course_code"
  end

  create_table "public.medhub_period_ids", id: false, force: :cascade do |t|
    t.integer "courseID"
    t.date "end_date"
    t.integer "periodID"
    t.date "start_date"
    t.index ["courseID", "periodID"], name: "medhub_period_ids_idx"
  end

  create_table "public.meetings", id: :serial, force: :cascade do |t|
    t.string "academic_discussed_other"
    t.string "academic_outcomes_other"
    t.string "advice_category"
    t.text "advisor_discussed", default: [], array: true
    t.integer "advisor_id"
    t.text "advisor_notes"
    t.text "advisor_outcomes", default: [], array: true
    t.string "advisor_type"
    t.string "career_discussed_other"
    t.string "career_outcomes_other"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "date", precision: nil
    t.integer "event_id"
    t.boolean "graduated_student"
    t.string "location"
    t.string "m_status"
    t.json "nbme_form"
    t.text "notes"
    t.json "qbank_info"
    t.text "study_resources", default: [], array: true
    t.string "study_resources_other"
    t.string "subject", array: true
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.json "uworld_info"
    t.index ["advisor_id", "id"], name: "index_meetings_on_advisor_id_and_id", unique: true
    t.index ["event_id", "id"], name: "index_meetings_on_event_id_and_id", unique: true
    t.index ["user_id"], name: "index_meetings_on_user_id"
  end

  create_table "public.messages", id: :serial, force: :cascade do |t|
    t.boolean "archived", default: false
    t.text "content"
    t.datetime "created_at", precision: nil, null: false
    t.integer "room_id"
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "public.meta_attribute_entity_groups", id: :serial, force: :cascade do |t|
    t.text "group_name", null: false
    t.text "parent_table", null: false
    t.string "parent_table_pk", limit: 255
    t.boolean "visible", default: true
  end

  create_table "public.meta_attribute_groups", id: :serial, force: :cascade do |t|
    t.text "group_name", null: false
    t.text "parent_table", null: false
    t.boolean "visible", default: true
  end

  create_table "public.new_competencies", force: :cascade do |t|
    t.text "add_comm_on_perform"
    t.text "clinic_exp_comment"
    t.text "comm_prof_concerns"
    t.string "course_id"
    t.string "course_name"
    t.datetime "created_at", null: false
    t.string "email"
    t.date "end_date"
    t.string "environment"
    t.string "evaluator"
    t.text "feedback"
    t.string "final_grade"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.string "medhub_id"
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.text "mspe"
    t.text "overall_summ_comm_perf"
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "permission_group_id"
    t.integer "pppd1", limit: 2
    t.integer "pppd2", limit: 2
    t.text "prof_concerns"
    t.integer "sbp1", limit: 2
    t.date "start_date"
    t.string "student_uid"
    t.date "submit_date"
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.index ["permission_group_id", "user_id", "id"], name: "idx_on_permission_group_id_user_id_id_9b61cec064", unique: true
    t.index ["user_id", "id"], name: "index_new_competencies_on_user_id_and_id", unique: true
  end

  create_table "public.permission_groups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.text "pinned_survey_group_titles"
    t.text "title", null: false
    t.datetime "updated_at", precision: nil
  end

  create_table "public.permission_ls_group_filters", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.boolean "filter_all", default: false
    t.text "ident_type"
    t.integer "lime_question_qid"
    t.integer "permission_ls_group_id", null: false
    t.text "restricted_val"
    t.datetime "updated_at", precision: nil
    t.index ["permission_ls_group_id", "lime_question_qid"], name: "uniq_qid_by_group", unique: true
  end

  create_table "public.permission_ls_groups", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.boolean "enabled", default: false
    t.integer "lime_survey_sid", null: false
    t.integer "permission_group_id", null: false
    t.datetime "updated_at", precision: nil
    t.boolean "view_all", default: false
    t.boolean "view_raw", default: false
    t.index ["lime_survey_sid", "permission_group_id"], name: "uniq_sid_by_group", unique: true
  end

  create_table "public.precep_meetings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "meeting_date"
    t.string "meeting_notes"
    t.string "meeting_with"
    t.string "other_present"
    t.string "student_name"
    t.string "student_sid"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_precep_meetings_on_user_id"
  end

  create_table "public.preceptor_assesses", force: :cascade do |t|
    t.boolean "attribute1"
    t.text "attribute1_no"
    t.boolean "attribute2"
    t.text "attribute2_no"
    t.boolean "attribute3"
    t.text "attribute3_no"
    t.string "concern_comments"
    t.datetime "created_at", precision: nil, null: false
    t.text "feedback"
    t.string "grade"
    t.text "overall_performance"
    t.string "preceptor_email"
    t.string "preceptor_name"
    t.string "professional_concerns"
    t.string "response_id"
    t.date "submit_date"
    t.string "term"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["response_id"], name: "index_preceptor_assesses_on_response_id"
    t.index ["user_id"], name: "index_preceptor_assesses_on_user_id"
  end

  create_table "public.preceptor_evals", force: :cascade do |t|
    t.text "comments"
    t.string "concern_comments"
    t.datetime "created_at", precision: nil, null: false
    t.string "grade"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.text "mspe_comments"
    t.integer "pbli1", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "permission_group_id"
    t.integer "pppd1", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd9", limit: 2
    t.string "preceptor_name"
    t.string "professional_concerns"
    t.integer "sbpic2", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.date "submit_date"
    t.string "term"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["user_id", "permission_group_id"], name: "by_user_permission_group_id"
    t.index ["user_id"], name: "index_preceptor_evals_on_user_id"
  end

  create_table "public.question_widgets", id: :serial, force: :cascade do |t|
    t.string "agg", limit: 255
    t.datetime "created_at", precision: nil
    t.string "graph_type", limit: 255
    t.integer "lime_question_qid"
    t.string "pk", limit: 255
    t.integer "role_aggregate_id"
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
    t.string "view_type"
  end

  create_table "public.role_aggregates", id: :serial, force: :cascade do |t|
    t.text "agg_fieldname"
    t.string "agg_label", limit: 255
    t.string "agg_title_fieldname", limit: 255
    t.datetime "created_at", precision: nil
    t.string "default_view", limit: 255
    t.integer "lime_survey_sid"
    t.string "pk_fieldname", limit: 255
    t.string "pk_label", limit: 255
    t.string "pk_title_fieldname", limit: 255
    t.datetime "updated_at", precision: nil
    t.string "view_type", limit: 255
  end

  create_table "public.rooms", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.integer "discussable_id"
    t.string "discussable_type"
    t.string "identifier"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "public.student_lists", primary_key: "sid", id: { type: :string, limit: 10 }, force: :cascade do |t|
    t.string "full_name", limit: 50
    t.integer "permission_group_id"
    t.bigint "user_id"
  end

  create_table "public.temp_competencies", id: false, force: :cascade do |t|
    t.text "add_comm_on_perform"
    t.text "clinic_exp_comment"
    t.text "comm_prof_concerns"
    t.string "course_id"
    t.string "course_name"
    t.datetime "created_at", precision: nil
    t.string "email"
    t.date "end_date"
    t.string "environment"
    t.string "evaluator"
    t.text "feedback"
    t.string "final_grade"
    t.integer "ics1", limit: 2
    t.integer "ics2", limit: 2
    t.integer "ics3", limit: 2
    t.integer "ics4", limit: 2
    t.integer "ics5", limit: 2
    t.integer "ics6", limit: 2
    t.integer "ics7", limit: 2
    t.integer "ics8", limit: 2
    t.bigint "id"
    t.string "medhub_id"
    t.integer "mk1", limit: 2
    t.integer "mk2", limit: 2
    t.integer "mk3", limit: 2
    t.integer "mk4", limit: 2
    t.integer "mk5", limit: 2
    t.text "mspe"
    t.text "overall_summ_comm_perf"
    t.integer "pbli1", limit: 2
    t.integer "pbli2", limit: 2
    t.integer "pbli3", limit: 2
    t.integer "pbli4", limit: 2
    t.integer "pbli5", limit: 2
    t.integer "pbli6", limit: 2
    t.integer "pbli7", limit: 2
    t.integer "pbli8", limit: 2
    t.integer "pcp1", limit: 2
    t.integer "pcp2", limit: 2
    t.integer "pcp3", limit: 2
    t.integer "pcp4", limit: 2
    t.integer "pcp5", limit: 2
    t.integer "pcp6", limit: 2
    t.bigint "permission_group_id"
    t.integer "pppd1", limit: 2
    t.integer "pppd10", limit: 2
    t.integer "pppd11", limit: 2
    t.integer "pppd2", limit: 2
    t.integer "pppd3", limit: 2
    t.integer "pppd4", limit: 2
    t.integer "pppd5", limit: 2
    t.integer "pppd6", limit: 2
    t.integer "pppd7", limit: 2
    t.integer "pppd8", limit: 2
    t.integer "pppd9", limit: 2
    t.text "prof_concerns"
    t.integer "sbpic1", limit: 2
    t.integer "sbpic2", limit: 2
    t.integer "sbpic3", limit: 2
    t.integer "sbpic4", limit: 2
    t.integer "sbpic5", limit: 2
    t.date "start_date"
    t.string "student_uid"
    t.date "submit_date"
    t.datetime "updated_at", precision: nil
    t.bigint "user_id"
  end

  create_table "public.ume_assess_plans", force: :cascade do |t|
    t.string "assessment_description"
    t.string "competency"
    t.datetime "created_at", null: false
    t.string "method"
    t.string "resource"
    t.boolean "rubric_used"
    t.string "student_learning_objective"
    t.string "target"
    t.boolean "target_met"
    t.string "target_results"
    t.datetime "updated_at", null: false
    t.string "year"
  end

  create_table "public.ume_blses", force: :cascade do |t|
    t.string "comments"
    t.datetime "created_at", null: false
    t.date "expiration_date"
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_ume_blses_on_user_id"
  end

  create_table "public.user_externals", id: :serial, force: :cascade do |t|
    t.string "ident", limit: 255
    t.string "ident_type", limit: 255
    t.boolean "use_email", default: false
    t.integer "user_id"
  end

  create_table "public.users", id: :serial, force: :cascade do |t|
    t.string "career_interest", default: [], array: true
    t.string "coaching_type"
    t.integer "cohort_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "current_sign_in_at", precision: nil
    t.string "current_sign_in_ip", limit: 255
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "former_name"
    t.string "full_name", limit: 255
    t.boolean "is_ldap", default: false
    t.datetime "last_sign_in_at", precision: nil
    t.string "last_sign_in_ip", limit: 255
    t.datetime "locked_at", precision: nil
    t.string "ls_list_state", default: "dirty"
    t.date "matriculated_date"
    t.boolean "new_competency", default: false
    t.text "p4_program_id"
    t.integer "permission_group_id"
    t.integer "prev_permission_group_id"
    t.datetime "remember_created_at", precision: nil
    t.datetime "reset_password_sent_at", precision: nil
    t.string "reset_password_token", limit: 255
    t.text "roles"
    t.string "sid"
    t.integer "sign_in_count", default: 0
    t.string "spec_program"
    t.boolean "subscribed", default: false, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "username", limit: 255
    t.uuid "uuid", default: -> { "uuid_generate_v4()" }, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["sid"], name: "index_users_on_sid", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
    t.index ["uuid"], name: "index_users_on_uuid", unique: true
  end

  create_table "public.usmle_exams", force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.datetime "exam_date", precision: nil
    t.integer "exam_score"
    t.string "exam_type"
    t.integer "no_attempts"
    t.string "pass_fail"
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_usmle_exams_on_user_id"
  end

  create_table "public.version_notes", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil, null: false
    t.text "note"
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "public.versions", id: :serial, force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "event", limit: 255, null: false
    t.integer "item_id", null: false
    t.string "item_type", limit: 255, null: false
    t.text "object"
    t.text "object_changes"
    t.integer "version_note_id"
    t.string "whodunnit", limit: 255
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["version_note_id"], name: "index_versions_on_version_note_id"
  end

  add_foreign_key "public.active_storage_variant_records", "public.active_storage_blobs", column: "blob_id"
  add_foreign_key "public.artifacts", "public.users"
  add_foreign_key "public.cohorts", "public.users"
  add_foreign_key "public.competencies", "public.permission_groups"
  add_foreign_key "public.competencies", "public.users"
  add_foreign_key "public.course_schedules", "public.courses"
  add_foreign_key "public.csl_evals", "public.users"
  add_foreign_key "public.csl_feedbacks", "public.users"
  add_foreign_key "public.eg_cohorts", "public.users"
  add_foreign_key "public.epa_masters", "public.users"
  add_foreign_key "public.epas", "public.users"
  add_foreign_key "public.fom_exams", "public.users"
  add_foreign_key "public.formative_feedbacks", "public.users"
  add_foreign_key "public.med18_competencies", "public.permission_groups"
  add_foreign_key "public.med19_competencies", "public.permission_groups"
  add_foreign_key "public.med20_competencies", "public.permission_groups"
  add_foreign_key "public.med21_competencies", "public.permission_groups"
  add_foreign_key "public.med23_mspes", "public.users"
  add_foreign_key "public.med24_mspes", "public.users"
  add_foreign_key "public.med25_mspes", "public.users"
  add_foreign_key "public.med26_mspes", "public.users"
  add_foreign_key "public.med27_mspes", "public.users"
  add_foreign_key "public.precep_meetings", "public.users"
  add_foreign_key "public.preceptor_assesses", "public.users"
  add_foreign_key "public.preceptor_evals", "public.users"
  add_foreign_key "public.student_lists", "public.users"
  add_foreign_key "public.usmle_exams", "public.users"

  create_table "target.meta_attribute_entities", id: :serial, force: :cascade do |t|
    t.integer "edition"
    t.text "entity_type", null: false
    t.string "entity_type_fk", limit: 255
    t.text "meta_attribute_entity_group_group_name", null: false
    t.integer "reference_year"
    t.date "start_date"
    t.date "stop_date"
    t.integer "version"
    t.boolean "visible", default: true
    t.index ["entity_type"], name: "ix_meta_attribute_entities", unique: true
  end

  create_table "target.meta_attribute_questions", id: :serial, force: :cascade do |t|
    t.text "attribute_name"
    t.text "category"
    t.boolean "continuous"
    t.text "data_type"
    t.text "description"
    t.text "meta_attribute_entity_entity_type", null: false
    t.boolean "optional"
    t.text "options_hash"
    t.text "original_text"
    t.text "short_name"
    t.boolean "visible", default: true
  end

  create_table "target.meta_attribute_statistics", primary_key: "meta_attribute_statistic_id", id: :bigint, default: nil, force: :cascade do |t|
    t.string "attribute_data_type"
    t.string "attribute_description"
    t.bigint "attribute_index"
    t.string "attribute_name"
    t.decimal "ci_lower"
    t.decimal "ci_upper"
    t.decimal "count"
    t.string "entity_name"
    t.string "entity_schema"
    t.boolean "is_continuous", default: false, null: false
    t.decimal "max"
    t.decimal "mean"
    t.decimal "min"
    t.decimal "n"
    t.decimal "n_percent", precision: 5, scale: 2
    t.decimal "stddev"
    t.decimal "subset_ci_lower"
    t.decimal "subset_ci_upper"
    t.decimal "subset_count"
    t.string "subset_id"
    t.decimal "subset_max"
    t.decimal "subset_mean"
    t.decimal "subset_min"
    t.decimal "subset_n"
    t.decimal "subset_n_percent", precision: 5, scale: 2
    t.decimal "subset_stddev"
    t.index ["subset_id", "entity_schema", "entity_name", "attribute_name"], name: "ix_meta_attribute_statistics", unique: true
  end

  create_table "target.meta_attribute_values", primary_key: "meta_attribute_value_id", id: :bigint, default: nil, force: :cascade do |t|
    t.string "attribute_name"
    t.decimal "count"
    t.string "entity_name"
    t.string "entity_schema"
    t.bigint "meta_attribute_statistic_id"
    t.decimal "subset_count"
    t.string "subset_id"
    t.decimal "value"
    t.string "value_description"
    t.index ["meta_attribute_statistic_id"], name: "ix_meta_attribute_statistic_id"
    t.index ["subset_id", "entity_schema", "entity_name", "attribute_name", "value"], name: "ix_meta_attribute_values", unique: true
  end

  create_table "transform.critical_values", primary_key: ["alpha", "df"], force: :cascade do |t|
    t.decimal "alpha", default: "0.05", null: false
    t.integer "df", null: false
    t.decimal "t", null: false
    t.check_constraint "df >= 1", name: "critical_values_df_check"
  end

  create_table "source.meta_attribute_values", primary_key: ["entity_schema", "entity_name", "attribute_name", "value"], force: :cascade do |t|
    t.string "attribute_name", null: false
    t.string "entity_name", null: false
    t.string "entity_schema", null: false
    t.decimal "value", null: false
    t.string "value_description"
  end
end
