class CreateStockCorrections < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_corrections do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, default: 0
      t.float :price
      t.timestamps
    end
  end
end
