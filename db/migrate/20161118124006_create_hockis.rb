class CreateHockis < ActiveRecord::Migration[5.0]
  def change
    create_table :hockis do |t|
      t.string :mahocki
      t.integer :dinhmuchocphi
      t.date :bd
      t.date :kt
      t.boolean :modangkilophoc
    end
  end
end
