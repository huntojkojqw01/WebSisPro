class CreateGiaoviens < ActiveRecord::Migration[5.0]
  def change
    create_table :giaoviens do |t|
      t.string :magv
      t.string :tengv
      t.string :ngaysinh
      t.string :email
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
