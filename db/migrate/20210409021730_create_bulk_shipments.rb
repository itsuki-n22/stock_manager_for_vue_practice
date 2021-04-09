class CreateBulkShipments < ActiveRecord::Migration[6.1]
  def change
    create_table :bulk_shipments do |t|
      t.string :name, null: false
      t.references :delivery_agent, foreign_key: true
      t.integer :delivery_charge
      t.string :tracking_number
      t.integer :phase, default: 0
      t.integer :from, null: false
      t.integer :to, null: false
      t.date :ship_date
      t.date :arrived_date

      t.timestamps
    end
  end
end
