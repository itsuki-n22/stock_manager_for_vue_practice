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
class Platform < ApplicationRecord
  has_many :orders
  validates :name, uniqueness: true
end
