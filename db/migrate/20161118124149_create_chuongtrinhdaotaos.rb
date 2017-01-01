class CreateChuongtrinhdaotaos < ActiveRecord::Migration[5.0]
  def change
    create_table :chuongtrinhdaotaos do |t|
      t.integer :hocki
      t.references :lopsinhvien, foreign_key: true
      t.references :hocphan, foreign_key: true     
    end
    add_index "chuongtrinhdaotaos", ["lopsinhvien_id", "hocphan_id"], :unique => true    
  end
  
end
