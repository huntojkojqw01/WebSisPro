class AddDiemToDkLop < ActiveRecord::Migration[5.0]
  def change
    add_column :dk_lops, :diem, :float
  end
end
