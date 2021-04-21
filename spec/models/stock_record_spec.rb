# == Schema Information
#
# Table name: stock_records
#
#  id              :bigint           not null, primary key
#  new_price       :float
#  quantity        :integer
#  reason          :string
#  recordable_type :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  product_id      :bigint           not null
#  recordable_id   :bigint
#  stock_place_id  :integer
#
# Indexes
#
#  index_stock_records_on_product_id  (product_id)
#  index_stock_records_on_recordable  (recordable_type,recordable_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
require 'rails_helper'

RSpec.describe StockRecord, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
