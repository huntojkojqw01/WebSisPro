class CreateLophocs < ActiveRecord::Migration[5.0]
  def change
    create_table :lophocs do |t|
      t.string :malp
      t.string :phonghoc
      t.string :thoigian
      t.references :hocphan, foreign_key: true
      t.references :giaovien, foreign_key: true

      t.timestamps
    end
  end
end
