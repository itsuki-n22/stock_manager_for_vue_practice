# == Schema Information
#
# Table name: bulk_shipping_items
#
#  id               :bigint           not null, primary key
#  price            :integer          default(0)
#  quantity         :integer          default(1)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  bulk_shipment_id :bigint           not null
#  product_id       :bigint           not null
#
# Indexes
#
#  index_bulk_shipping_items_on_bulk_shipment_id  (bulk_shipment_id)
#  index_bulk_shipping_items_on_product_id        (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (bulk_shipment_id => bulk_shipments.id)
#  fk_rails_...  (product_id => products.id)
#
class BulkShippingItem < ApplicationRecord
  belongs_to :bulk_shipment
  belongs_to :product

end
