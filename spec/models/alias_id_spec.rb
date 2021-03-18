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
require 'rails_helper'

RSpec.describe AliasId, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
