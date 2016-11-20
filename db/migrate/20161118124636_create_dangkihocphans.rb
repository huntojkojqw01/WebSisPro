class CreateDangkihocphans < ActiveRecord::Migration[5.0]
  def change
    create_table :dangkihocphans do |t|
      t.references :sinhvien, foreign_key: true
      t.references :hocphan, foreign_key: true
      t.references :hocki, foreign_key: true
    end
  end
end