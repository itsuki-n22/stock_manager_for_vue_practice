# == Schema Information
#
# Table name: orders
#
#  id              :bigint           not null, primary key
#  address         :string
#  customer_name   :string
#  delivery_charge :integer
#  order_number    :string           not null
#  phone_country   :integer
#  phone_number    :string
#  postal_code     :string
#  prefecture      :integer          default("北海道"), not null
#  status          :integer          default("注文直後"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  platform_id     :bigint
#
# Indexes
#
#  index_orders_on_order_number  (order_number)
#  index_orders_on_platform_id   (platform_id)
#  index_orders_on_status        (status)
#
# Foreign Keys
#
#  fk_rails_...  (platform_id => platforms.id)
#
require 'rails_helper'

RSpec.describe Order, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
