class CreateSkus < ActiveRecord::Migration[5.2]
  def change
    create_table :skus do |t|
      t.string :outer_id, limit: 9
      t.string :supplier_code, limit: 6, index: true
      t.string :field_1
      t.string :field_2
      t.string :field_3
      t.string :field_4
      t.string :field_5
      t.string :field_6
      t.decimal :price, precision: 12, scale: 2

      t.timestamps
    end

    add_index :skus, :outer_id, unique: true
  end
end
