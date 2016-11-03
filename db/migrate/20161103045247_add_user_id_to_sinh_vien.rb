class AddUserIdToSinhVien < ActiveRecord::Migration[5.0]
  def change
    add_column :sinh_viens, :user_id, :string
  end
end
