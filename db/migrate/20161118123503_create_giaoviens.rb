class CreateGiaoviens < ActiveRecord::Migration[5.0]
  def change
    create_table :giaoviens do |t|
      t.string :magiaovien
      t.string :tengiaovien
      t.string :ngaysinh
      t.string :email
      t.references :khoavien, foreign_key: true      
    end
  end
end
