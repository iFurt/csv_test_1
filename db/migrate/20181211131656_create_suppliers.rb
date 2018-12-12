class CreateSuppliers < ActiveRecord::Migration[5.2]
  def change
    create_table :suppliers do |t|
      t.string :code, limit: 6
      t.string :name

      t.timestamps
    end

    add_index :suppliers, :code, unique: true
  end
end
