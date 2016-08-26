# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151112231229) do

  create_table "admins", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.datetime "confirmed_at"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "memberships", force: true do |t|
    t.integer  "m_type"
    t.decimal  "total_bought",    precision: 10, scale: 0
    t.integer  "payments_count"
    t.datetime "expire_date"
    t.datetime "last_payment_at"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["user_id"], name: "index_memberships_on_user_id"

  create_table "messages", force: true do |t|
    t.string   "recipient"
    t.string   "sender"
    t.integer  "status"
    t.text     "message_text"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "msg_type"
    t.integer  "priority"
  end

  add_index "messages", ["user_id", "created_at"], name: "index_mensajes_on_user_id_and_created_at"

  create_table "price_pairs", force: true do |t|
    t.integer  "amount"
    t.decimal  "price",      precision: 16, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "userdata", force: true do |t|
    t.string   "nombre"
    t.string   "apellido"
    t.integer  "tipo"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "city"
    t.string   "state"
  end

  add_index "userdata", ["user_id", "created_at"], name: "index_userdata_on_user_id_and_created_at"

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "authentication_token"
    t.datetime "confirmed_at"
    t.string   "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "name"
    t.string   "provider"
    t.string   "uid"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token"
  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["provider"], name: "index_users_on_provider"
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["uid"], name: "index_users_on_uid"

  create_table "wallets", force: true do |t|
    t.integer  "credits_count"
    t.integer  "credits_left"
    t.decimal  "total_bought",   precision: 10, scale: 0
    t.integer  "payments_count"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wallets", ["user_id"], name: "index_wallets_on_user_id"

end
