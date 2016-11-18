class CreateHocphans < ActiveRecord::Migration[5.0]
  def change
    create_table :hocphans do |t|
      t.string :mahocphan
      t.string :tenhocphan
      t.integer :tinchi
      t.integer :tinchihocphi
      t.integer :trongso
      t.boolean :modangki
      t.references :khoavien, foreign_key: true      
    end
  end
end
