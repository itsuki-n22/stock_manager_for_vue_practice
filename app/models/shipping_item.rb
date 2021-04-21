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
class ShippingItem < ApplicationRecord
  after_initialize :set_default_destination_and_departure
  belongs_to :order
  belongs_to :product
  belongs_to :delivery_agent
  belongs_to :departure, class_name:'StockPlace', foreign_key: "from" 
  belongs_to :destination, class_name:'StockPlace', foreign_key: "to" 
  has_many :stock_records, as: :recordable
  validates_uniqueness_of :order_id, scope: :product_id

  def set_default_destination_and_departure
    # TODO StockPlaceのクエリ、こんなに発行する必要ないので後でリファクタ
    # デフォルトの配送先と配送元を登録されたStockPlaceからIDを取得する
    self.to = StockPlace.all.where(has_quantity: false).first.id if to == nil || to == 0
    self.from = StockPlace.all.where(has_quantity: true).first.id if from == nil || from == 0
  end
end
