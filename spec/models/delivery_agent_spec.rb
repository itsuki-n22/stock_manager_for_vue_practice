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
require 'rails_helper'

RSpec.describe DeliveryAgent, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
