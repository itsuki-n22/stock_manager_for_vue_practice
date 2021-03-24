class CreateProductRelationships < ActiveRecord::Migration[6.1]
  def change
    create_table :product_relationships do |t|
      t.integer :origin_id, null: false
      t.integer :item_id, null: false
      t.integer :quantity, null: false

      t.timestamps
    end
    add_index :product_relationships, :origin_id
    add_index :product_relationships, :item_id
    add_index :product_relationships, [:origin_id, :item_id], unique: true
  end
end
