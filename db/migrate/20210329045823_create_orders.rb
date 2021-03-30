class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false
      t.string :customer_name
      t.integer :postal_code
      t.string :prefecture
      t.string :address
      t.integer :phone_country
      t.integer :phone_number
      t.integer :delivery_charge
      t.integer :platform, null: false, default: 0
      t.integer :status, null: false, default: 0
      t.timestamps
    end
    add_index :orders, :order_number
    add_index :orders, :status
  end
end
