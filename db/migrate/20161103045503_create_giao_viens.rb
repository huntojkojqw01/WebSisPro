class CreateGiaoViens < ActiveRecord::Migration[5.0]
  def change
    create_table :giao_viens do |t|
      t.string :magv
      t.string :tengv
      t.string :ngaysinh
      t.string :email
      t.string :user_id

      t.timestamps
    end
  end
end
