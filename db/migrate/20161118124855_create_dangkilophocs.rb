class CreateDangkilophocs < ActiveRecord::Migration[5.0]
  def change
    create_table :dangkilophocs do |t|
      t.float :diemquatrinh
      t.float :diemthi
      t.float :diemso
      t.string :diemchu
      t.float :hesohocphi
      t.string :trangthaidangki
      t.references :sinhvien, foreign_key: true
      t.references :lophoc, foreign_key: true      
    end
  end
end
