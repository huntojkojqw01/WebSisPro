class CreateDkLops < ActiveRecord::Migration[5.0]
  def change
    create_table :dk_lops do |t|
      t.integer :sinh_vien_id
      t.integer :lop_hoc_id

      t.timestamps
    end
  end
end
