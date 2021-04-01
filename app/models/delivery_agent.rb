# == Schema Information
#
# Table name: delivery_agents
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  track_url  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class DeliveryAgent < ApplicationRecord
  has_many :shipping_items
end
