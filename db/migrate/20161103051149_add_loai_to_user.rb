class AddLoaiToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :loai, :string
  end
end
