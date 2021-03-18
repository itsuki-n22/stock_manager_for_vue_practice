class CreateStocks < ActiveRecord::Migration[6.1]
  def change
    create_table :stocks do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :place, null: false
      t.integer :quantity, null: false, default: 0

      t.timestamps
    end
  end
end
