class CreateLopsinhviens < ActiveRecord::Migration[5.0]
  def change
    create_table :lopsinhviens do |t|
      t.string :tenlopsinhvien
      t.string :khoahoc
      t.references :giaovien, foreign_key: true
      t.references :khoavien, foreign_key: true
    end
  end
end
