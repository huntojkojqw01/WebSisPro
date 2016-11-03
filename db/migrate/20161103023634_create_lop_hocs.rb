class CreateLopHocs < ActiveRecord::Migration[5.0]
  def change
    create_table :lop_hocs do |t|
      t.string :malh
      t.string :phonghoc
      t.string :thoigian
      t.integer :mahp_id

      t.timestamps
    end
  end
end
