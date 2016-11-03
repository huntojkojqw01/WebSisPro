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

ActiveRecord::Schema.define(version: 20161103093049) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dk_lops", force: :cascade do |t|
    t.integer  "sinh_vien_id"
    t.integer  "lop_hoc_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.float    "diem"
  end

  create_table "giao_viens", force: :cascade do |t|
    t.string   "magv"
    t.string   "tengv"
    t.string   "ngaysinh"
    t.string   "email"
    t.string   "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "hoc_phans", force: :cascade do |t|
    t.string   "mahp"
    t.string   "tenhp"
    t.integer  "tc"
    t.integer  "tchp"
    t.integer  "heso"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean  "open"
  end

  create_table "lop_hocs", force: :cascade do |t|
    t.string   "malh"
    t.string   "phonghoc"
    t.string   "thoigian"
    t.integer  "mahp_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "hocphan_id"
  end

  create_table "sinh_viens", force: :cascade do |t|
    t.string   "masv"
    t.string   "tensv"
    t.date     "ngaysinh"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "type"
    t.string   "loai"
  end

end