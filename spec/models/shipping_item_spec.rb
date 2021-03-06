# == Schema Information
#
# Table name: shipping_items
#
#  id                :bigint           not null, primary key
#  from              :integer          default(0)
#  is_sent           :boolean
#  price             :integer          default(0), not null
#  quantity          :integer          default(1), not null
#  to                :integer          default(0)
#  tracking_number   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  delivery_agent_id :bigint           default(3)
#  order_id          :bigint           not null
#  product_id        :bigint           not null
#
# Indexes
#
#  index_shipping_items_on_delivery_agent_id  (delivery_agent_id)
#  index_shipping_items_on_order_id           (order_id)
#  index_shipping_items_on_product_id         (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (delivery_agent_id => delivery_agents.id)
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe ShippingItem, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
