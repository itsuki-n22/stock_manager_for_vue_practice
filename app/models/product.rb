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

  def first_image_url
    # 紐づいている画像のURLを取得する
    images.attached? ? url_for(images.first) : nil
  end    

end
