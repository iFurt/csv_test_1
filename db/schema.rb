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

ActiveRecord::Schema.define(version: 2018_12_11_131706) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "skus", force: :cascade do |t|
    t.string "outer_id", limit: 9
    t.string "supplier_code", limit: 6
    t.string "field_1"
    t.string "field_2"
    t.string "field_3"
    t.string "field_4"
    t.string "field_5"
    t.string "field_6"
    t.decimal "price", precision: 12, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["outer_id"], name: "index_skus_on_outer_id", unique: true
    t.index ["supplier_code"], name: "index_skus_on_supplier_code"
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "code", limit: 6
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_suppliers_on_code", unique: true
  end

end
