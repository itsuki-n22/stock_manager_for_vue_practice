# == Schema Information
#
# Table name: products
#
#  id         :bigint           not null, primary key
#  code       :string           not null
#  explain    :text
#  is_set     :boolean          default(FALSE)
#  name       :string
#  price      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Product < ApplicationRecord
  include Rails.application.routes.url_helpers
  after_save :init_params
  validates :code, uniqueness: true
  validates :is_set, inclusion: {in: [true, false]}

  has_one :memo, class_name: "ProductMemo", dependent: :destroy
  has_many_attached :images
  has_many :stocks, dependent: :destroy
  has_many :alias_ids, dependent: :destroy
  has_many :set_relationship, class_name: "ProductRelationship", foreign_key: "origin_id", dependent: :destroy
  has_many :set_products, through: :set_relationship, source: :item

  def add_set_item(product, num=1)
    set_relationship.create(item_id: product.id, quantity: num)
  end

  def remove_set_item(product)
    set_relationship.find_by(item_id: product.id).destroy
  end

  def set_item?(product)
    set_products.include?(product)
  end

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
    if stocks.empty?
      Stock.places.each do |place, place_num|
        stocks.create(place: place_num, quantity: 0)
      end
    end
    if alias_ids.empty?
      AliasId.code_types.each do |code_type, code_number|
        if code_number == 0
          alias_ids.create(code_type: code_type, code: code)
        else
          alias_ids.create(code_type: code_type, code: "")
        end
      end
    end
  end

end
