class CreateHocphans < ActiveRecord::Migration[5.0]
  def change
    create_table :hocphans do |t|
      t.string :mahocphan
      t.string :tenhocphan
      t.float :tinchi
      t.float :tinchihocphi
      t.float :trongso
      t.boolean :modangki
      t.references :khoavien, foreign_key: true      
    end
  end
end
