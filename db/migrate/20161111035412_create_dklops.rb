class CreateDklops < ActiveRecord::Migration[5.0]
  def change
    create_table :dklops do |t|
      t.float :diem
      t.references :sinhvien, foreign_key: true
      t.references :lophoc, foreign_key: true

      t.timestamps
    end
  end
end
