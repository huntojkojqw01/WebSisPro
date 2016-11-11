class CreateSinhviens < ActiveRecord::Migration[5.0]
  def change
    create_table :sinhviens do |t|
      t.string :masv
      t.string :tensv
      t.string :ngaysinh
      t.string :email
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
