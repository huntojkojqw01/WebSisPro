class CreateLophocs < ActiveRecord::Migration[5.0]
  def change
    create_table :lophocs do |t|
      t.string :malophoc
      t.integer :maxdangki
      t.integer :thoigian, :limit => 8
      t.string :diadiem
      t.references :giaovien, foreign_key: true
      t.references :hocphan, foreign_key: true
      t.references :hocki, foreign_key: true
    end
  end
end
