# == Schema Information
#
# Table name: product_relationships
#
#  id         :bigint           not null, primary key
#  quantity   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  item_id    :integer          not null
#  origin_id  :integer          not null
#
# Indexes
#
#  index_product_relationships_on_item_id                (item_id)
#  index_product_relationships_on_origin_id              (origin_id)
#  index_product_relationships_on_origin_id_and_item_id  (origin_id,item_id) UNIQUE
#
class ProductRelationship < ApplicationRecord
  belongs_to :origin, class_name: "Product"
  belongs_to :item, class_name: "Product"
  validates :origin_id, presence: true
  validates :item_id, presence: true

end
