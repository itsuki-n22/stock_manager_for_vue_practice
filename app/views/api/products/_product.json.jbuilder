json.extract! product, :code, :name, :price, :explain,
  :id, :is_set, :first_image_url, :image_urls
json.flag false
if product.is_set == true
  set_relationships = product.set_relationship
  set_price = 0
  available_stocks = {}
  json.set_products do 
    json.array! set_relationships do |set_relationship|
      item = Product.find(set_relationship.item_id)
      json.id item.id
      json.code item.code
      json.quantity set_relationship.quantity
      json.first_image_url item.first_image_url
      json.stocks do 
        item.stocks.each do |set_stock|
          if available_stocks[set_stock.place] 
            available_stocks[set_stock.place] = set_stock.quantity if available_stocks[set_stock.place] > set_stock.quantity
          else
            available_stocks[set_stock.place] = set_stock.quantity
          end
          json.set! set_stock.place do
            json.quantity set_stock.quantity
          end
        end
      end
      set_price += item.price
    end
  end
  json.price set_price
end
product.stocks.each do |stock|
  json.stocks do 
    json.set! stock.place do 
    json.id stock.id
    json.quantity stock.quantity
    json.quantity available_stocks[stock.place] if product.is_set == true
    end
  end
end  
product.alias_ids.each do |alias_id|
  json.alias_id do 
      json.set! alias_id.code_type do 
      json.id alias_id.id
      json.code alias_id.code
      end
  end
end  