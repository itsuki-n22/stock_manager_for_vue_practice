# == Schema Information
#
# Table name: alias_id_kinds
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  name       :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'

RSpec.describe AliasIdKind, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
