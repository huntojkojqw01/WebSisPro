class AddHocphanIdToLopHoc < ActiveRecord::Migration[5.0]
  def change
    add_column :lop_hocs, :hocphan_id, :integer
  end
end
