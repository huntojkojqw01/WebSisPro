class CreateDangkilophocs < ActiveRecord::Migration[5.0]
  def change
    create_table :dangkilophocs do |t|
      t.integer :diemquatrinh
      t.integer :diemthi
      t.integer :hesohocphi
      t.string :trangthaidangki
      t.references :sinhvien, foreign_key: true
      t.references :lophoc, foreign_key: true
      t.references :hocki, foreign_key: true
    end
  end
end
