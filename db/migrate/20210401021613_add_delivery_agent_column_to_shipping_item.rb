class AddDeliveryAgentColumnToShippingItem < ActiveRecord::Migration[6.1]
  def change
    add_reference :shipping_items, :delivery_agent, foreign_key: { to_table: :delivery_agents }
  end
end
