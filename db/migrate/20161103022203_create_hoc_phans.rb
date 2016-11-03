class CreateHocPhans < ActiveRecord::Migration[5.0]
  def change
    create_table :hoc_phans do |t|
      t.string :mahp
      t.string :tenhp
      t.integer :tc
      t.integer :tchp
      t.integer :heso

      t.timestamps
    end
  end
end
