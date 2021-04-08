class CreateStockPlaces < ActiveRecord::Migration[6.1]
  def change
    create_table :stock_places do |t|
      t.string :name

      t.timestamps
    end
  end
end
