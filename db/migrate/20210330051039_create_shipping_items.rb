class CreateShippingItems < ActiveRecord::Migration[6.1]
  def change
    create_table :shipping_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :price, null: false, default: 0
      t.integer :quantity, null: false, default: 1
      t.string :tracking_number
      t.boolean :is_sent

      t.timestamps
    end
  end
end
