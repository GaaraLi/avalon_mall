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

ActiveRecord::Schema.define(version: 20140514132739) do

  create_table "activate_codes", force: true do |t|
    t.string   "activate_code"
    t.integer  "card_id"
    t.integer  "channel_id"
    t.integer  "status"
    t.datetime "expiry_date"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "is_shut",       limit: 1, default: 0
  end

  create_table "activate_utilities", force: true do |t|
    t.string   "activate_code"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "addresses", force: true do |t|
    t.integer  "vendor_id"
    t.string   "street"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: true do |t|
    t.string   "username",               default: "", null: false
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "permission"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree

  create_table "attachments", force: true do |t|
    t.integer  "vendor_id",      default: 0,     null: false
    t.string   "vendor_picture"
    t.boolean  "main_pic",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_brands", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_models", force: true do |t|
    t.string   "name"
    t.integer  "car_set_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "car_sets", force: true do |t|
    t.string   "name"
    t.integer  "car_brand_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cards", force: true do |t|
    t.integer  "customer_id"
    t.integer  "service_combo_id"
    t.string   "card_number",               limit: 40
    t.string   "status",                    limit: 10
    t.datetime "activated_date"
    t.date     "expiring_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "repaid_tactic_customer_id",            default: 1
    t.datetime "end_time"
    t.integer  "repaid_time"
  end

  create_table "cars", force: true do |t|
    t.integer  "customer_id"
    t.integer  "car_model_id"
    t.string   "plate_number"
    t.datetime "bought_since"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "channels", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consumption_appointments", force: true do |t|
    t.integer  "card_id"
    t.datetime "appointment_time"
    t.integer  "extra_service_detail_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "appointment_detail"
    t.integer  "appointment_test",        default: 0
  end

  create_table "consumption_records", force: true do |t|
    t.integer  "vendor_binding_record_id"
    t.integer  "service_id"
    t.boolean  "consumed_by_card",         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id"
  end

  create_table "customer_memos", force: true do |t|
    t.integer  "customer_id"
    t.text     "memo_info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "customers", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "nickname"
    t.string   "gender"
    t.string   "address"
    t.string   "phone"
    t.integer  "cash_account",           default: 0
    t.datetime "block_time"
    t.string   "customer_order_times"
  end

  add_index "customers", ["confirmation_token"], name: "index_customers_on_confirmation_token", unique: true, using: :btree
  add_index "customers", ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree

  create_table "extra_consumption_records", force: true do |t|
    t.integer  "vendor_id"
    t.integer  "customer_id"
    t.integer  "extra_service_detail_id"
    t.float    "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extra_service_details", force: true do |t|
    t.integer  "extra_service_type_id"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "extra_service_types", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gift_customers", force: true do |t|
    t.integer  "vendor_id"
    t.integer  "gift_id"
    t.integer  "customer_id"
    t.datetime "used_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gift_vendors", force: true do |t|
    t.integer  "vendor_id"
    t.integer  "gift_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gifts", force: true do |t|
    t.string   "name"
    t.string   "desc"
    t.integer  "expiring_days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "condition"
    t.string   "gift_times",    limit: 45
  end

  create_table "kindeditor_assets", force: true do |t|
    t.string   "asset"
    t.integer  "file_size"
    t.string   "file_type"
    t.integer  "owner_id"
    t.string   "asset_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_activities", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_areas", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_block_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_blocks", force: true do |t|
    t.string   "title",              limit: 100
    t.integer  "mall_block_type_id"
    t.string   "text1"
    t.string   "text2"
    t.string   "text3"
    t.string   "text4"
    t.string   "text5"
    t.string   "img_url"
    t.text     "text_area"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_categories", force: true do |t|
    t.string   "code"
    t.string   "name",           limit: 100
    t.integer  "level"
    t.string   "parent_code",    limit: 10
    t.string   "complete_code",  limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_order"
  end

  create_table "mall_exchanges", force: true do |t|
    t.string   "exchange_code_number"
    t.integer  "status",               default: 0
    t.integer  "mall_order_line_id"
    t.string   "order_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "used_time"
  end

  create_table "mall_goods", force: true do |t|
    t.string   "title"
    t.text     "desc"
    t.string   "logo_url1"
    t.string   "logo_url2"
    t.string   "logo_url3"
    t.string   "logo_url4"
    t.integer  "status"
    t.integer  "vendor_id"
    t.integer  "mall_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "logo_url1_file_name",    limit: 45
    t.string   "logo_url1_content_type", limit: 45
    t.string   "logo_url1_file_size",    limit: 45
    t.string   "subhead",                limit: 100
    t.string   "service_info"
  end

  create_table "mall_goods_activities", force: true do |t|
    t.integer  "mall_activity_id"
    t.integer  "mall_good_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_goods_properties", force: true do |t|
    t.string   "name"
    t.string   "content"
    t.integer  "mall_good_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_inventories", force: true do |t|
    t.integer  "inventory_qty"
    t.integer  "mall_sku_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_inventory_records", force: true do |t|
    t.integer  "mall_inventory_id"
    t.integer  "inventory_type"
    t.integer  "inventory_qty"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_order_lines", force: true do |t|
    t.decimal  "price",          precision: 10, scale: 2
    t.decimal  "original_price", precision: 10, scale: 2
    t.integer  "quantity"
    t.integer  "mall_order_id"
    t.integer  "mall_sku_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id"
    t.integer  "customer_id"
  end

  create_table "mall_orders", force: true do |t|
    t.string   "order_no"
    t.decimal  "price",                precision: 10, scale: 2
    t.decimal  "original_price",       precision: 10, scale: 2
    t.integer  "quantity"
    t.integer  "status"
    t.integer  "customer_id"
    t.datetime "finish_time"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "input_name"
    t.string   "input_phone"
    t.integer  "car_model_id"
    t.string   "input_plate_number"
    t.string   "customer_order_times"
  end

  create_table "mall_shopping_cars", force: true do |t|
    t.decimal  "price",          precision: 10, scale: 2
    t.decimal  "original_price", precision: 10, scale: 2
    t.integer  "quantity"
    t.integer  "mall_sku_id"
    t.integer  "vendor_id"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "mall_skus", force: true do |t|
    t.string   "code",           limit: 100
    t.string   "desc",           limit: 100
    t.decimal  "show_price",                 precision: 10, scale: 2
    t.decimal  "customer_price",             precision: 10, scale: 2
    t.decimal  "price",                      precision: 10, scale: 2
    t.integer  "mall_good_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "sale_count",                                          default: 0
  end

  create_table "permission_items", force: true do |t|
    t.string   "title"
    t.string   "name"
    t.text     "permission"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "renewals", force: true do |t|
    t.integer  "customer_id"
    t.integer  "transaction_id"
    t.date     "renewal_start"
    t.date     "renewal_end"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repaid_histories", force: true do |t|
    t.integer  "card_id"
    t.integer  "consumption_amount"
    t.integer  "repaid_amount"
    t.integer  "repaid_tactic_customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vendor_id"
    t.integer  "extra_consumption_record_id"
  end

  create_table "repaid_tactic_customers", force: true do |t|
    t.integer  "consumption_amount"
    t.integer  "repaid_amount"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "duration"
    t.integer  "times"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "expired",            default: 0
    t.integer  "next_rule",          default: 0
    t.integer  "start_rule",         default: 0
  end

  create_table "service_combos", force: true do |t|
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "service_items", force: true do |t|
    t.integer  "service_combo_id"
    t.integer  "service_id"
    t.integer  "amount"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "services", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", force: true do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id", using: :btree
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at", using: :btree

  create_table "simple_captcha_data", force: true do |t|
    t.string   "key",        limit: 40
    t.string   "value",      limit: 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "simple_captcha_data", ["key"], name: "idx_key", using: :btree

  create_table "staffs", force: true do |t|
    t.integer  "vendor_id",             default: 0,  null: false
    t.string   "name",       limit: 40, default: "", null: false
    t.string   "gender",     limit: 10, default: "", null: false
    t.string   "phone",      limit: 40
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "supplementations", force: true do |t|
    t.integer  "service_id"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "system_configs", force: true do |t|
    t.string   "app_key"
    t.string   "app_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.string   "name"
    t.string   "pwd"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "third_parties", force: true do |t|
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "third_party_consumptions", force: true do |t|
    t.integer  "third_party_customer_id"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "third_party_customers", force: true do |t|
    t.integer  "customer_id"
    t.string   "code"
    t.string   "cus_name"
    t.string   "phone"
    t.string   "plate_number",         limit: 45
    t.integer  "vendor_id"
    t.integer  "car_model_id"
    t.integer  "status"
    t.integer  "cus_type"
    t.date     "start_time"
    t.date     "end_time"
    t.integer  "expiring_month_count"
    t.integer  "wash_count"
    t.integer  "third_party_id"
    t.string   "ext1"
    t.string   "ext2"
    t.string   "ext3"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transactions", force: true do |t|
    t.float    "total_fee"
    t.string   "trade_status"
    t.string   "trade_no"
    t.datetime "notify_time"
    t.text     "raw_post"
    t.string   "buyer_email"
    t.integer  "customer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "card_no"
    t.string   "order_no"
    t.integer  "status"
  end

  create_table "transfer_codes", force: true do |t|
    t.integer  "customer_id"
    t.string   "code"
    t.integer  "old_cus_account"
    t.integer  "new_cus_cash"
    t.string   "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "transfer_customers", force: true do |t|
    t.integer  "transfer_code_id"
    t.integer  "customer_id"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_advices", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.string   "user_name"
    t.string   "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_binding_records", force: true do |t|
    t.integer  "card_id"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_goods", force: true do |t|
    t.string   "title"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",      default: 0
  end

  create_table "vendor_recommendations", force: true do |t|
    t.string   "user_name"
    t.string   "user_phone"
    t.string   "vendor_name"
    t.string   "vendor_add"
    t.integer  "acreage"
    t.string   "reason"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_wx_bindings", force: true do |t|
    t.string   "user_open_id"
    t.integer  "user_id"
    t.integer  "state",        default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_wx_consumption_records", force: true do |t|
    t.integer  "vendor_wx_user_id"
    t.integer  "vendor_good_id"
    t.datetime "consumption_time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_wx_user_goods", force: true do |t|
    t.integer  "vendor_wx_user_id"
    t.integer  "vendor_good_id"
    t.integer  "quantity",          default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendor_wx_users", force: true do |t|
    t.string   "name"
    t.string   "plate_number"
    t.string   "phone"
    t.string   "insurance_number"
    t.date     "insurance_end_date"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vendors", force: true do |t|
    t.string   "name",                   limit: 80, default: "", null: false
    t.text     "description"
    t.text     "manifesto"
    t.string   "phone1",                 limit: 40
    t.string   "phone2",                 limit: 40
    t.string   "boss_name",              limit: 40
    t.string   "boss_gender",            limit: 10
    t.string   "boss_phone",             limit: 40
    t.string   "manager_name",           limit: 40
    t.string   "manager_gender",         limit: 10
    t.string   "manager_phone",          limit: 40
    t.integer  "max_capacity"
    t.text     "opening_hours"
    t.text     "service_detail"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "shortname"
    t.text     "announcement"
    t.integer  "xiangche_certification", limit: 1
    t.integer  "product_certification",  limit: 1
    t.integer  "vip_certification",      limit: 1
    t.integer  "butler_certification",   limit: 1
    t.string   "service_info"
    t.string   "banner_url"
    t.integer  "is_mall",                limit: 1
    t.integer  "mall_area_id"
    t.text     "advertisement"
    t.integer  "vendor_order"
    t.integer  "is_xiangche",            limit: 1,  default: 0
    t.integer  "is_xiangche_bind",       limit: 1,  default: 1
  end

  add_index "vendors", ["reset_password_token"], name: "index_vendors_on_reset_password_token", unique: true, using: :btree

  create_table "vendors_public_keys", force: true do |t|
    t.integer  "vendor_id"
    t.string   "vendor_public_key"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "withdraw_cashes", force: true do |t|
    t.integer  "customer_id"
    t.string   "id_card"
    t.string   "bank_no"
    t.string   "bank_card_name"
    t.string   "bank_name"
    t.string   "mobile_phone"
    t.integer  "status"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wx_bindings", force: true do |t|
    t.string   "user_open_id"
    t.string   "user_login_name"
    t.integer  "state",           default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zx_pay_configs", force: true do |t|
    t.text "signer_crt"
    t.text "signer_key"
    t.text "key_passwd"
    t.text "trusted_crt"
  end

  create_table "zx_pays", force: true do |t|
    t.integer  "third_party_customer_id"
    t.string   "order_no"
    t.float    "order_price"
    t.text     "post_content"
    t.text     "get_content"
    t.text     "post_cipher"
    t.text     "get_cipher"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
