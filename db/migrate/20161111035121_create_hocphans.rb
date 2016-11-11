class CreateHocphans < ActiveRecord::Migration[5.0]
  def change
    create_table :hocphans do |t|
      t.string :mahp
      t.string :tenhp
      t.integer :tc
      t.integer :tchp
      t.integer :heso
      t.boolean :open

      t.timestamps
    end
  end
end
