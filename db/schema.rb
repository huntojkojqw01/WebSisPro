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

ActiveRecord::Schema.define(version: 20170127010827) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chuongtrinhdaotaos", force: :cascade do |t|
    t.integer "hocki"
    t.integer "lopsinhvien_id"
    t.integer "hocphan_id"
    t.index ["hocphan_id"], name: "index_chuongtrinhdaotaos_on_hocphan_id", using: :btree
    t.index ["lopsinhvien_id", "hocphan_id"], name: "index_chuongtrinhdaotaos_on_lopsinhvien_id_and_hocphan_id", unique: true, using: :btree
    t.index ["lopsinhvien_id"], name: "index_chuongtrinhdaotaos_on_lopsinhvien_id", using: :btree
  end

  create_table "dangkihocphans", force: :cascade do |t|
    t.integer "sinhvien_id"
    t.integer "hocphan_id"
    t.integer "hocki_id"
    t.index ["hocki_id"], name: "index_dangkihocphans_on_hocki_id", using: :btree
    t.index ["hocphan_id"], name: "index_dangkihocphans_on_hocphan_id", using: :btree
    t.index ["sinhvien_id"], name: "index_dangkihocphans_on_sinhvien_id", using: :btree
  end

  create_table "dangkilophocs", force: :cascade do |t|
    t.float   "diemquatrinh"
    t.float   "diemthi"
    t.float   "diemso"
    t.string  "diemchu"
    t.float   "hesohocphi"
    t.integer "sinhvien_id"
    t.integer "lophoc_id"
    t.index ["lophoc_id"], name: "index_dangkilophocs_on_lophoc_id", using: :btree
    t.index ["sinhvien_id"], name: "index_dangkilophocs_on_sinhvien_id", using: :btree
  end

  create_table "giaoviens", force: :cascade do |t|
    t.string  "magiaovien"
    t.string  "tengiaovien"
    t.date    "ngaysinh"
    t.string  "email"
    t.integer "khoavien_id"
    t.index ["khoavien_id"], name: "index_giaoviens_on_khoavien_id", using: :btree
  end

  create_table "hockis", force: :cascade do |t|
    t.string  "mahocki"
    t.integer "dinhmuchocphi"
    t.date    "bd"
    t.date    "kt"
    t.boolean "modangkihocphan"
    t.boolean "modangkilophoc"
  end

  create_table "hocphans", force: :cascade do |t|
    t.string  "mahocphan"
    t.string  "tenhocphan"
    t.float   "tinchi"
    t.float   "tinchihocphi"
    t.float   "trongso"
    t.integer "khoavien_id"
    t.index ["khoavien_id"], name: "index_hocphans_on_khoavien_id", using: :btree
  end

  create_table "hungs", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "khoaviens", force: :cascade do |t|
    t.string "tenkhoavien"
    t.string "sodienthoai"
    t.string "diadiem"
  end

  create_table "lophocs", force: :cascade do |t|
    t.string  "malophoc"
    t.integer "maxdangki"
    t.bigint  "thoigian"
    t.string  "diadiem"
    t.integer "giaovien_id"
    t.integer "hocphan_id"
    t.integer "hocki_id"
    t.index ["giaovien_id"], name: "index_lophocs_on_giaovien_id", using: :btree
    t.index ["hocki_id"], name: "index_lophocs_on_hocki_id", using: :btree
    t.index ["hocphan_id"], name: "index_lophocs_on_hocphan_id", using: :btree
  end

  create_table "lopsinhviens", force: :cascade do |t|
    t.string  "tenlopsinhvien"
    t.string  "khoahoc"
    t.integer "giaovien_id"
    t.integer "khoavien_id"
    t.index ["giaovien_id"], name: "index_lopsinhviens_on_giaovien_id", using: :btree
    t.index ["khoavien_id"], name: "index_lopsinhviens_on_khoavien_id", using: :btree
  end

  create_table "sinhviens", force: :cascade do |t|
    t.string  "masinhvien"
    t.string  "tensinhvien"
    t.date    "ngaysinh"
    t.string  "email"
    t.boolean "trangthai"
    t.integer "lopsinhvien_id"
    t.integer "user_id"
    t.index ["lopsinhvien_id"], name: "index_sinhviens_on_lopsinhvien_id", using: :btree
    t.index ["user_id"], name: "index_sinhviens_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "password_digest"
    t.string "remember_digest"
    t.string "loai"
  end

  add_foreign_key "chuongtrinhdaotaos", "hocphans"
  add_foreign_key "chuongtrinhdaotaos", "lopsinhviens"
  add_foreign_key "dangkihocphans", "hockis"
  add_foreign_key "dangkihocphans", "hocphans"
  add_foreign_key "dangkihocphans", "sinhviens"
  add_foreign_key "dangkilophocs", "lophocs"
  add_foreign_key "dangkilophocs", "sinhviens"
  add_foreign_key "giaoviens", "khoaviens"
  add_foreign_key "hocphans", "khoaviens"
  add_foreign_key "lophocs", "giaoviens"
  add_foreign_key "lophocs", "hockis"
  add_foreign_key "lophocs", "hocphans"
  add_foreign_key "lopsinhviens", "giaoviens"
  add_foreign_key "lopsinhviens", "khoaviens"
  add_foreign_key "sinhviens", "lopsinhviens"
  add_foreign_key "sinhviens", "users"
end
