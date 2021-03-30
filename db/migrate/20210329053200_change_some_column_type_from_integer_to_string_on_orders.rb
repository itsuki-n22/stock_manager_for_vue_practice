class ChangeSomeColumnTypeFromIntegerToStringOnOrders < ActiveRecord::Migration[6.1]
  def change
    change_column :orders, :phone_number, :string
    change_column :orders, :postal_code, :string
  end
end
