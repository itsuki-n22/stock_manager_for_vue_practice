class RemovePlaceColumnsFromStocks < ActiveRecord::Migration[6.1]
  def change
    remove_column :stocks, :place, :integer
  end
end
