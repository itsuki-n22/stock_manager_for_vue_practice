class CreateBulkShippingItems < ActiveRecord::Migration[6.1]
  def change
    create_table :bulk_shipping_items do |t|
      t.integer :price, default: 0
      t.integer :quantity, default: 1
      t.references :bulk_shipment, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
