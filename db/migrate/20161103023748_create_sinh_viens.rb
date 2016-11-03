class CreateSinhViens < ActiveRecord::Migration[5.0]
  def change
    create_table :sinh_viens do |t|
      t.string :masv
      t.string :tensv
      t.date :ngaysinh
      t.string :email

      t.timestamps
    end
  end
end
