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

ActiveRecord::Schema.define(version: 20171210234457) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "class_appointment_attachments", force: :cascade do |t|
    t.integer  "appointment_id"
    t.string   "content_file_name",    null: false
    t.string   "content_content_type", null: false
    t.integer  "content_file_size",    null: false
    t.datetime "content_updated_at",   null: false
    t.index ["appointment_id"], name: "index_class_appointment_attachments_on_appointment_id", using: :btree
  end

  create_table "class_appointments", force: :cascade do |t|
    t.integer  "teacher_id", null: false
    t.integer  "student_id", null: false
    t.datetime "starts_at",  null: false
    t.datetime "ends_at",    null: false
    t.integer  "kind",       null: false
    t.string   "place_desc"
    t.text     "desc"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "status",     null: false
    t.index ["ends_at"], name: "index_class_appointments_on_ends_at", using: :btree
    t.index ["starts_at"], name: "index_class_appointments_on_starts_at", using: :btree
    t.index ["student_id"], name: "index_class_appointments_on_student_id", using: :btree
    t.index ["teacher_id"], name: "index_class_appointments_on_teacher_id", using: :btree
  end

  create_table "defaults", force: :cascade do |t|
    t.float    "hourly_price"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "locations", force: :cascade do |t|
    t.integer  "user_id",                             null: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.decimal  "latitude",   precision: 10, scale: 6
    t.decimal  "longitude",  precision: 10, scale: 6
    t.string   "name"
    t.string   "address"
    t.integer  "radius"
    t.index ["user_id"], name: "index_locations_on_user_id", using: :btree
  end

  create_table "mercado_pago_credentials", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "access_token"
    t.string   "public_key"
    t.string   "refresh_token"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["user_id"], name: "index_mercado_pago_credentials_on_user_id", using: :btree
  end

  create_table "study_subject_links", force: :cascade do |t|
    t.integer  "study_subject_id"
    t.integer  "user_id"
    t.integer  "class_appointment_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["class_appointment_id"], name: "index_study_subject_links_on_class_appointment_id", using: :btree
    t.index ["study_subject_id"], name: "index_study_subject_links_on_study_subject_id", using: :btree
    t.index ["user_id"], name: "index_study_subject_links_on_user_id", using: :btree
  end

  create_table "study_subjects", force: :cascade do |t|
    t.string   "level"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_availability_periods", force: :cascade do |t|
    t.integer  "starts_at_sfsow"
    t.integer  "ends_at_sfsow"
    t.integer  "week_day"
    t.integer  "user_id",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["user_id"], name: "index_user_availability_periods_on_user_id", using: :btree
  end

  create_table "user_taught_subjects", force: :cascade do |t|
    t.string   "name",       null: false
    t.string   "level"
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_taught_subjects_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                  null: false
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.text     "roles",                     default: [],              array: true
    t.string   "school_year"
    t.string   "phone_number"
    t.integer  "age"
    t.string   "description"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.boolean  "teaches_online"
    t.boolean  "teaches_at_own_place"
    t.boolean  "teaches_at_students_place"
    t.boolean  "teaches_at_public_place"
    t.text     "neighborhoods",             default: [],              array: true
    t.string   "short_desc"
    t.text     "long_desc"
    t.integer  "mercado_pago_user_id"
    t.decimal  "hourly_price"
    t.float    "price"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "whiteboard_signals", force: :cascade do |t|
    t.string   "function_name",        null: false
    t.json     "args",                 null: false
    t.datetime "date",                 null: false
    t.integer  "class_appointment_id", null: false
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.index ["class_appointment_id"], name: "index_whiteboard_signals_on_class_appointment_id", using: :btree
  end

  add_foreign_key "class_appointment_attachments", "class_appointments", column: "appointment_id"
  add_foreign_key "class_appointments", "users", column: "student_id"
  add_foreign_key "class_appointments", "users", column: "teacher_id"
  add_foreign_key "locations", "users"
  add_foreign_key "mercado_pago_credentials", "users"
  add_foreign_key "study_subject_links", "class_appointments"
  add_foreign_key "study_subject_links", "study_subjects"
  add_foreign_key "study_subject_links", "users"
  add_foreign_key "whiteboard_signals", "class_appointments"
end
