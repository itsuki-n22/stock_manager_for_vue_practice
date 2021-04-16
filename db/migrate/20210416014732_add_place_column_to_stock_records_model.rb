class AddPlaceColumnToStockRecordsModel < ActiveRecord::Migration[6.1]
  def change
    add_reference :stock_records, :stock_place, null: false, foreign_key: true
  end
end
