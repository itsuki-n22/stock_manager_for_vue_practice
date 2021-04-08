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

ActiveRecord::Schema.define(version: 2021_04_08_055720) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "alias_id_kinds", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "alias_ids", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "alias_id_kind_id"
    t.index ["alias_id_kind_id"], name: "index_alias_ids_on_alias_id_kind_id"
    t.index ["product_id"], name: "index_alias_ids_on_product_id"
  end

  create_table "delivery_agents", force: :cascade do |t|
    t.string "name", null: false
    t.string "track_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_memos", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_memos_on_order_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_number", null: false
    t.string "customer_name"
    t.string "postal_code"
    t.integer "prefecture", default: 0, null: false
    t.string "address"
    t.integer "phone_country"
    t.string "phone_number"
    t.integer "delivery_charge"
    t.integer "platform", default: 0, null: false
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_number"], name: "index_orders_on_order_number"
    t.index ["status"], name: "index_orders_on_status"
  end

  create_table "product_memos", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["product_id"], name: "index_product_memos_on_product_id"
  end

  create_table "product_relationships", force: :cascade do |t|
    t.integer "origin_id", null: false
    t.integer "item_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["item_id"], name: "index_product_relationships_on_item_id"
    t.index ["origin_id", "item_id"], name: "index_product_relationships_on_origin_id_and_item_id", unique: true
    t.index ["origin_id"], name: "index_product_relationships_on_origin_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "code", null: false
    t.string "name"
    t.text "explain"
    t.integer "price", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "is_set", default: false
  end

  create_table "shipping_items", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "product_id", null: false
    t.integer "price", default: 0, null: false
    t.integer "quantity", default: 1, null: false
    t.string "tracking_number"
    t.boolean "is_sent"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "delivery_agent_id", default: 3
    t.index ["delivery_agent_id"], name: "index_shipping_items_on_delivery_agent_id"
    t.index ["order_id"], name: "index_shipping_items_on_order_id"
    t.index ["product_id"], name: "index_shipping_items_on_product_id"
  end

  create_table "stock_places", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "stocks", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "stock_place_id"
    t.index ["product_id"], name: "index_stocks_on_product_id"
    t.index ["stock_place_id"], name: "index_stocks_on_stock_place_id"
  end

  create_table "todos", force: :cascade do |t|
    t.bigint "user_id"
    t.string "title", default: "", null: false
    t.string "body", default: ""
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_todos_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", default: "no-user-name", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alias_ids", "products"
  add_foreign_key "order_memos", "orders"
  add_foreign_key "product_memos", "products"
  add_foreign_key "shipping_items", "delivery_agents"
  add_foreign_key "shipping_items", "orders"
  add_foreign_key "shipping_items", "products"
  add_foreign_key "stocks", "products"
  add_foreign_key "stocks", "stock_places"
  add_foreign_key "todos", "users"
end
