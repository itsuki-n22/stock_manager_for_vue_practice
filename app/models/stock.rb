# == Schema Information
#
# Table name: stocks
#
#  id             :bigint           not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  product_id     :bigint           not null
#  stock_place_id :bigint
#
# Indexes
#
#  index_stocks_on_product_id      (product_id)
#  index_stocks_on_stock_place_id  (stock_place_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#  fk_rails_...  (stock_place_id => stock_places.id)
#
class Stock < ApplicationRecord
  belongs_to :product
  belongs_to :stock_place
  has_many :stock_details, dependent: :destroy

  def quantity
    stock_details.inject(0){|result,item| result + item.quantity }
  end

  def total_price
    stock_details.inject(0){|result,item| result + (item.quantity * item.price) }
  end

  def ave_price
    ave_price = total_price / quantity
    return 0 if ave_price.nan?
    ave_price
  end
    
end
