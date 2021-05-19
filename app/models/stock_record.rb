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
class StockRecord < ApplicationRecord
  belongs_to :recordable, polymorphic: true
  belongs_to :product
  before_create :reflect_stocks_on_create
#  before_destroy :reflect_stocks_on_destroy
#  
  private
    def reflect_stocks_on_create
      stock = Stock.where(product_id: product_id, stock_place_id: stock_place_id).first # TODO 書き直せ
      if new_price
        sum_price = stock.quantity * stock.ave_price + quantity * new_price
        if stock.quantity + quantity > 0 
          stock.ave_price = sum_price / (stock.quantity + quantity) 
        else
          stock.ave_price = 0
        end
      else
        stock.stock_details.where('quantity > 0').order(:asc)
      end
      stock.ave_price = 0 if stock.ave_price < 0
      stock.quantity = stock.quantity + quantity
      stock.save!
    end
#
#    def reflect_stocks_on_destroy
#      stock = Stock.where(product_id: product_id, stock_place_id: stock_place_id).first # TODO 書き直せ
#      if new_price
#        sum_price = stock.quantity * stock.ave_price - quantity * new_price
#        if stock.quantity - quantity > 0
#          stock.ave_price = sum_price / (stock.quantity - quantity)
#        else
#          stock.ave_price = 0
#        end
#      end
#      stock.ave_price = 0 if stock.ave_price < 0
#      stock.quantity = stock.quantity - quantity
#      stock.save!
#    end
#
    def corrected_price
      if new_price == 0 || new_price == nil || new_price == ""
        
      end
    end
end
