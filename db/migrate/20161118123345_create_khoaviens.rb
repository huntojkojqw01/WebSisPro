class CreateKhoaviens < ActiveRecord::Migration[5.0]
  def change
    create_table :khoaviens do |t|
      t.string :tenkhoavien
      t.string :sodienthoai
      t.string :diadiem
    end
  end
end
