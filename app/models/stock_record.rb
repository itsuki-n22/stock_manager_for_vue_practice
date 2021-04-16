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
#  stock_place_id  :bigint           not null
#
# Indexes
#
#  index_stock_records_on_product_id      (product_id)
#  index_stock_records_on_recordable      (recordable_type,recordable_id)
#  index_stock_records_on_stock_place_id  (stock_place_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (stock_place_id => stock_places.id)
#
class StockRecord < ApplicationRecord
  belongs_to :recordable, polymorphic: true
  belongs_to :product
  
  private
    def reflect_stocks
    end
end
