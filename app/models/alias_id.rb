# == Schema Information
#
# Table name: alias_ids
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  code_type  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  product_id :bigint           not null
#
# Indexes
#
#  index_alias_ids_on_product_id  (product_id)
#
# Foreign Keys
#
#  fk_rails_...  (product_id => products.id)
#
class AliasId < ApplicationRecord
  belongs_to :product
  enum code_type: [:sku, :asin, :other_id, :car_id ]
end
