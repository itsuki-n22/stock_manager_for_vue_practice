# == Schema Information
#
# Table name: stock_details
#
#  id         :bigint           not null, primary key
#  price      :float
#  quantity   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  stock_id   :bigint           not null
#
# Indexes
#
#  index_stock_details_on_stock_id  (stock_id)
#
# Foreign Keys
#
#  fk_rails_...  (stock_id => stocks.id)
#
require 'rails_helper'

RSpec.describe StockDetail, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
