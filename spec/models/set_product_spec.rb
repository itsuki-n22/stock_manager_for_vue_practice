# == Schema Information
#
# Table name: set_products
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer          not null
#  origin_id  :integer          not null
#
# Indexes
#
#  index_set_products_on_item_id                (item_id)
#  index_set_products_on_origin_id              (origin_id)
#  index_set_products_on_origin_id_and_item_id  (origin_id,item_id) UNIQUE
#
require 'rails_helper'

RSpec.describe SetProduct, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
