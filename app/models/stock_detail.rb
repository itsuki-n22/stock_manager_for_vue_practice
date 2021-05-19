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
class StockDetail < ApplicationRecord
  #[quantity = 0　は一つだけ保存。それ以外のquantity=0の保存が要求された場合、それは無視する。
  belongs_to :stock
end
