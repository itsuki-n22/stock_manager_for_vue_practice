# == Schema Information
#
# Table name: shipping_items
#
#  id              :bigint           not null, primary key
#  is_sent         :boolean
#  price           :integer          default(0), not null
#  quantity        :integer          default(1), not null
#  tracking_number :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  order_id        :bigint           not null
#  product_id      :bigint           not null
#
# Indexes
#
#  index_shipping_items_on_order_id    (order_id)
#  index_shipping_items_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (order_id => orders.id)
#  fk_rails_...  (product_id => products.id)
#
class ShippingItem < ApplicationRecord
  belongs_to :order
  belongs_to :product
  validates_uniqueness_of :order_id, scope: :product_id
end
