class RemoveAvePriceAndQuantityColumnFromStock < ActiveRecord::Migration[6.1]
  def change
    remove_column :stocks, :ave_price, :float, default: 0
    remove_column :stocks, :quantity, :integer, default: 0
  end
end
