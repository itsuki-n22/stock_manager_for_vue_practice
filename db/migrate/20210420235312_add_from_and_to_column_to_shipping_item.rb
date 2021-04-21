class AddFromAndToColumnToShippingItem < ActiveRecord::Migration[6.1]
  def change
    add_column :shipping_items, :to, :integer, default: 0
    add_column :shipping_items, :from, :integer, default: 0
  end
end
