# == Schema Information
#
# Table name: bulk_shipments
#
#  id                :bigint           not null, primary key
#  arrived_date      :date
#  delivery_charge   :integer
#  from              :integer          not null
#  name              :string           not null
#  phase             :integer          default(0)
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
require 'rails_helper'

RSpec.describe BulkShipment, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
