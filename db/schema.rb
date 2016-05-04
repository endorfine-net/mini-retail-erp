# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140906124921) do

  create_table "colors", :force => true do |t|
    t.string "alias",     :null => false
    t.string "code",      :null => false
    t.string "primary",   :null => false
    t.string "secondary"
  end

  create_table "item_operation_types", :force => true do |t|
    t.string "alias", :null => false
  end

  create_table "item_operations", :force => true do |t|
    t.integer  "item_id",                                                              :null => false
    t.integer  "user_id",                                                              :null => false
    t.integer  "location_id",                                                          :null => false
    t.integer  "item_operation_type_id",                                               :null => false
    t.decimal  "price",                  :precision => 10, :scale => 2,                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "discount"
    t.string   "note"
    t.integer  "payment_type_id",                                       :default => 1
    t.decimal  "default_price",          :precision => 10, :scale => 2
  end

  add_index "item_operations", ["item_id"], :name => "index_item_operations_on_item_id"
  add_index "item_operations", ["location_id"], :name => "index_item_operations_on_location_id"
  add_index "item_operations", ["user_id"], :name => "index_item_operations_on_user_id"

  create_table "item_quantities", :force => true do |t|
    t.integer  "item_id",          :null => false
    t.integer  "location_id",      :null => false
    t.boolean  "is_delivered"
    t.integer  "amount_delivered"
    t.integer  "amount_current"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "product_id",       :null => false
  end

  add_index "item_quantities", ["item_id"], :name => "index_item_quantities_on_item_id"
  add_index "item_quantities", ["location_id"], :name => "index_item_quantities_on_location_id"
  add_index "item_quantities", ["product_id"], :name => "index_item_quantities_on_product_id"

  create_table "items", :force => true do |t|
    t.integer  "product_id",                                     :null => false
    t.integer  "size"
    t.decimal  "delivery_price",  :precision => 10, :scale => 2
    t.integer  "total_delivered"
    t.integer  "total_in_stock"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",           :precision => 10, :scale => 2, :null => false
    t.decimal  "old_price",       :precision => 10, :scale => 2, :null => false
    t.integer  "color_id",                                       :null => false
  end

  add_index "items", ["color_id"], :name => "index_items_on_color_id"
  add_index "items", ["product_id"], :name => "index_items_on_product_id"

  create_table "locations", :force => true do |t|
    t.integer  "status_id",     :default => 1, :null => false
    t.string   "alias",                        :null => false
    t.string   "address"
    t.integer  "location_type", :default => 2, :null => false
    t.string   "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_name",                   :null => false
  end

  add_index "locations", ["status_id"], :name => "index_locations_on_status_id"

  create_table "logs", :force => true do |t|
    t.integer  "user_id",                                                :null => false
    t.integer  "location_id",                                            :null => false
    t.string   "action_type",                                            :null => false
    t.string   "affected_entity_type"
    t.integer  "affected_entity_id"
    t.string   "ip_address",                                             :null => false
    t.string   "human_readable_text",                                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "note"
    t.decimal  "price",                   :precision => 10, :scale => 2
    t.integer  "quantity"
    t.integer  "destination_location_id"
    t.integer  "source_location_id"
    t.decimal  "default_price",           :precision => 10, :scale => 2
  end

  add_index "logs", ["location_id"], :name => "index_logs_on_location_id"
  add_index "logs", ["user_id"], :name => "index_logs_on_user_id"

  create_table "payment_types", :force => true do |t|
    t.string "alias", :null => false
  end

  create_table "product_types", :force => true do |t|
    t.string "alias"
  end

  create_table "products", :force => true do |t|
    t.integer  "user_id",                            :null => false
    t.integer  "status_id",          :default => 1,  :null => false
    t.string   "alias",              :default => "", :null => false
    t.string   "product_code",                       :null => false
    t.integer  "product_type_id",                    :null => false
    t.integer  "collection_year"
    t.integer  "collection_season"
    t.string   "note"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "products", ["product_type_id"], :name => "index_products_on_product_type_id"
  add_index "products", ["status_id"], :name => "index_products_on_status_id"
  add_index "products", ["user_id"], :name => "index_products_on_user_id"

  create_table "request_statuses", :force => true do |t|
    t.string "alias"
  end

  create_table "requests", :force => true do |t|
    t.integer  "user_id",                 :null => false
    t.integer  "location_id",             :null => false
    t.integer  "request_status_id",       :null => false
    t.integer  "item_quantity_id",        :null => false
    t.integer  "source_location_id",      :null => false
    t.integer  "destination_location_id", :null => false
    t.string   "product_code",            :null => false
    t.integer  "quantity",                :null => false
    t.string   "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requests", ["item_quantity_id"], :name => "index_requests_on_item_quantity_id"
  add_index "requests", ["location_id"], :name => "index_requests_on_location_id"
  add_index "requests", ["request_status_id"], :name => "index_requests_on_request_status_id"
  add_index "requests", ["user_id"], :name => "index_requests_on_user_id"

  create_table "roles", :force => true do |t|
    t.string "alias"
  end

  create_table "statuses", :force => true do |t|
    t.string "alias"
  end

  create_table "system", :force => true do |t|
    t.string   "param"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                               :null => false
    t.string   "email",                               :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "password_salt",                       :null => false
    t.string   "persistence_token",                   :null => false
    t.string   "perishable_token",                    :null => false
    t.integer  "login_count",          :default => 0, :null => false
    t.integer  "failed_login_count",   :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "role_id",              :default => 5, :null => false
    t.integer  "status_id",            :default => 1, :null => false
    t.string   "alias",                               :null => false
    t.integer  "location_id",          :default => 1, :null => false
    t.string   "phone"
    t.string   "mobile"
    t.datetime "password_last_set_on",                :null => false
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["location_id"], :name => "index_users_on_location_id"
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"
  add_index "users", ["status_id"], :name => "index_users_on_status_id"

end
