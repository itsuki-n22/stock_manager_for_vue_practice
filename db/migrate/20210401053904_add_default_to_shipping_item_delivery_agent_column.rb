class AddDefaultToShippingItemDeliveryAgentColumn < ActiveRecord::Migration[6.1]
  def change
    change_column_default :shipping_items, :delivery_agent_id, from: nil, to: 3
  end
end
