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
class Stock < ApplicationRecord
  enum place: [ :office, :fba, :china]
  belongs_to :product
end
