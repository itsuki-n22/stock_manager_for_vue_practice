# == Schema Information
#
# Table name: platforms
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  url        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_platforms_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe Platform, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
