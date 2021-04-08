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
class AliasIdKind < ApplicationRecord
  has_many :alias_ids
  validates :code, presence: :true, uniqueness: true
  validates :name, presence: :true, uniqueness: true
end
