# == Schema Information
#
# Table name: stocks
#
#  id         :bigint           not null, primary key
#  place      :integer          not null
#  quantity   :integer          default(0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_stocks_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe Stock, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
