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
require 'rails_helper'

RSpec.describe StockPlace, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
