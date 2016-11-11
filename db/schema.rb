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

ActiveRecord::Schema.define(version: 20161111035412) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dklops", force: :cascade do |t|
    t.float    "diem"
    t.integer  "sinhvien_id"
    t.integer  "lophoc_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["lophoc_id"], name: "index_dklops_on_lophoc_id", using: :btree
    t.index ["sinhvien_id"], name: "index_dklops_on_sinhvien_id", using: :btree
  end

  create_table "giaoviens", force: :cascade do |t|
    t.string   "magv"
    t.string   "tengv"
    t.string   "ngaysinh"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_giaoviens_on_user_id", using: :btree
  end

  create_table "hocphans", force: :cascade do |t|
    t.string   "mahp"
    t.string   "tenhp"
    t.integer  "tc"
    t.integer  "tchp"
    t.integer  "heso"
    t.boolean  "open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lophocs", force: :cascade do |t|
    t.string   "malp"
    t.string   "phonghoc"
    t.string   "thoigian"
    t.integer  "hocphan_id"
    t.integer  "giaovien_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["giaovien_id"], name: "index_lophocs_on_giaovien_id", using: :btree
    t.index ["hocphan_id"], name: "index_lophocs_on_hocphan_id", using: :btree
  end

  create_table "sinhviens", force: :cascade do |t|
    t.string   "masv"
    t.string   "tensv"
    t.string   "ngaysinh"
    t.string   "email"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sinhviens_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "loai"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "dklops", "lophocs"
  add_foreign_key "dklops", "sinhviens"
  add_foreign_key "giaoviens", "users"
  add_foreign_key "lophocs", "giaoviens"
  add_foreign_key "lophocs", "hocphans"
  add_foreign_key "sinhviens", "users"
end
