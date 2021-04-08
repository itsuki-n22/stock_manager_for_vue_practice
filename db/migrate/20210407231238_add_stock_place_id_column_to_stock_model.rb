class AddStockPlaceIdColumnToStockModel < ActiveRecord::Migration[6.1]
  def up
    add_reference :stocks, :stock_place, foreign_key: true
    Stock.where(stock_place_id: nil).update_all(stock_place_id: 1)
  end

  def down
    remove_reference :stocks, :stock_place
  end
end
