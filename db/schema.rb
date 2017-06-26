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

ActiveRecord::Schema.define(version: 20170626081134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "images", force: :cascade do |t|
    t.string   "img_url"
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "product_id"
    t.string   "lazada_url"
  end

  add_index "images", ["product_id"], name: "index_images_on_product_id", using: :btree

  create_table "products", force: :cascade do |t|
    t.string   "shopify_id"
    t.string   "title"
    t.text     "description"
    t.string   "vendor"
    t.string   "handle"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "short_description"
    t.string   "model"
    t.string   "name_en"
    t.string   "seller_sku"
    t.string   "price"
    t.string   "package_content"
    t.string   "package_weight"
    t.string   "quantity"
    t.string   "weight"
  end

  create_table "shopify_shops", force: :cascade do |t|
    t.string   "shop_domain"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree

  create_table "tags", force: :cascade do |t|
    t.string   "title"
    t.string   "thai_title"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "shopify_shop_id"
    t.boolean  "is_group_tag"
    t.string   "group_tag_cat"
    t.string   "group_tag_sub"
    t.string   "group_tag_thai_cat"
    t.string   "group_tag_thai_sub"
  end

  add_index "tags", ["shopify_shop_id"], name: "index_tags_on_shopify_shop_id", using: :btree

  add_foreign_key "tags", "shopify_shops"
end
