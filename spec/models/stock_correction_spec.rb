# == Schema Information
#
# Table name: stock_corrections
#
#  id         :bigint           not null, primary key
#  price      :float
#  quantity   :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_stock_corrections_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe StockCorrection, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
