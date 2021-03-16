# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  explain    :text
#  name       :string
#  price      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
end
