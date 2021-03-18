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
  include Rails.application.routes.url_helpers

  has_many_attached :images
  has_many :stocks, dependent: :destroy
  has_many :alias_ids, dependent: :destroy

  def first_image_url
    images.attached? ? url_for(images.first) : nil
  end    

  def image_urls
    if images.attached? 
      Array.new(images.size){|n| url_for(images[n]) }
    else
      return []
    end
  end    

  def init_params
    Stock.places.each do |place, place_num|
      stocks.create(place: place_num, quantity: 0)
    end
    AliasId.code_types.each do |code_type, code_number|
      if code_number == 0
        alias_ids.create(code_type: code_type, code: code)
      else
        alias_ids.create(code_type: code_type, code: "")
      end
    end
  end

end
