class CreateStockDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_details do |t|
      t.float :price
      t.integer :quantity, null: false
      t.references :stock, null: false, foreign_key: true

      t.timestamps
    end
  end
end
