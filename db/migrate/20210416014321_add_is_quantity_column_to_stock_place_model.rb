class AddIsQuantityColumnToStockPlaceModel < ActiveRecord::Migration[6.1]
  def change
    add_column :stock_places, :has_quantity, :boolean, default: true
  end
end
