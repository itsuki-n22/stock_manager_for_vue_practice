# == Schema Information
#
# Table name: bulk_shipments
#
#  id                :bigint           not null, primary key
#  arrived_date      :date
#  delivery_charge   :integer
#  from              :integer          not null
#  name              :string           not null
#  phase             :integer          default("preparing")
#  ship_date         :date
#  to                :integer          not null
#  tracking_number   :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  delivery_agent_id :bigint
#
# Indexes
#
#  index_bulk_shipments_on_delivery_agent_id  (delivery_agent_id)
#
# Foreign Keys
#
#  fk_rails_...  (delivery_agent_id => delivery_agents.id)
#
class BulkShipment < ApplicationRecord
  belongs_to :delivery_agent, optional: true
  has_many :bulk_shipping_items
  has_one :stock_record, as: :recordable
  belongs_to :destination, class_name: 'StockPlace', foreign_key: "to"
  belongs_to :departure, class_name: 'StockPlace', foreign_key: "from"
  validates :from, presence: true
  validates :to, presence: true
  validates :name, presence: true
  enum phase: %w(preparing sent arrived lost)
end
