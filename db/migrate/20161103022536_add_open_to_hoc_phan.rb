class AddOpenToHocPhan < ActiveRecord::Migration[5.0]
  def change
    add_column :hoc_phans, :open, :boolean
  end
end
