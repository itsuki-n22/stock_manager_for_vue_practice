# == Schema Information
#
# Table name: stock_places
#
#  id           :bigint           not null, primary key
#  has_quantity :boolean          default(TRUE)
#  name         :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
class StockPlace < ApplicationRecord
  has_many :stocks
  validates :name, presence: :true, uniqueness: true
end
