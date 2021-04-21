# == Schema Information
#
# Table name: stock_records
#
#  id              :bigint           not null, primary key
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
class StockRecord < ApplicationRecord
  belongs_to :recordable, polymorphic: true
  belongs_to :product
  
  private
    def reflect_stocks
    end
end
