class AddPriceColumnToStockAndStockRecord < ActiveRecord::Migration[6.1]
  def change
    add_column :stock_records, :new_price, :float
    add_column :stocks, :ave_price, :float, default: 0
  end
end
