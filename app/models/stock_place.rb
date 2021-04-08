# == Schema Information
#
# Table name: stock_places
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class StockPlace < ApplicationRecord
    has_many :stocks
end
