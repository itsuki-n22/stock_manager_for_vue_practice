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
  validates :code, uniqueness: true, presence: true
  validates :is_set, inclusion: {in: [true, false]}

  has_one :shipping_items
  has_one :memo, class_name: "ProductMemo", dependent: :destroy
  has_many_attached :images
  has_many :stocks, dependent: :destroy
  has_many :stock_corrections, dependent: :destroy
  has_many :stock_details, dependent: :destroy
  has_many :alias_ids, dependent: :destroy
  has_many :set_relationship, class_name: "ProductRelationship", foreign_key: "origin_id", dependent: :destroy
  has_many :set_products, through: :set_relationship, source: :item

  scope :name_asc, -> { order(:name)}
  scope :name_desc, -> { order(name: :desc)}

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

  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      product = find_by(id: row["id"]) || find_by(code: row["code"]) || new
      this_id = product.id
      product.attributes = row.to_hash.slice(*updatable_product_attributes)

      csv_is_set = (row["is_set"] =~ /y/i) ? true : false
      next if this_id && csv_is_set != product.is_set

      product.id = this_id if this_id
      product.is_set = csv_is_set if this_id == nil

      if (product.is_set? && new_set_products(row).empty? == false ) || product.is_set? == false
        product.save
      else
        next
      end

      product.alias_ids.each_with_index do |alias_id|
        alias_id.code = alias_id_attributes(row)[alias_id.alias_id_kind.code] || ""
        alias_id.save
      end
      if product.is_set == false
        product.stocks.each_with_index do |stock|
          stock.quantity = stock_attributes(row)[stock.place].to_i || 0
          stock.save
        end
      else
        new_set_products(row).each do |new_set_product|
          new_set_item = Product.find_by(code: new_set_product)
          product.add_set_item(new_set_item)
        end
      end
    end
  end

  def self.updatable_product_attributes
    ["id", "code", "explain", "name", "price"]
  end
  
  def self.alias_id_attributes(row)
    row.to_hash.slice(*AliasIdKind.all.map(&:code))
  end

  def self.stock_attributes(row)
    #row.to_hash.slice(*Stock.places.keys)
    row.to_hash.slice(*StockPlace.all.map(&:name))
  end

  def self.new_set_products(row)
    row.to_hash.delete_if{|key,val| key !~ /set_product/ }.values.compact
  end

  def init_params
    if stocks.empty?
      StockPlace.all.each do |stock_place|
        if stock_place.has_quantity
          stock = stocks.create(stock_place_id: stock_place.id, quantity: 0) 
          stock.stock_details.create(quantity: 0, price: 0)
        end
      end
    end
    if alias_ids.empty?
      AliasIdKind.all.each do |alias_id_kind|
        if alias_id_kind.id == 1
          alias_ids.create(alias_id_kind_id: alias_id_kind.id, code: code)
        else
          alias_ids.create(alias_id_kind_id: alias_id_kind.id, code: "")
        end
      end
    end
  end

end
