json.array! @products do |product|
  json.code product.code
  json.explain product.explain
  json.id product.id
  json.name product.name
  json.price product.price
  product.stocks.each do |stock|
    json.stocks do 
      json.set! stock.place do 
        json.id stock.id
        json.quantity stock.quantity
      end
    end
  end  
  json.first_image_url product.first_image_url
  json.image_urls product.image_urls
  json.flag false
  product.alias_ids.each do |alias_id|
      json.alias_id do 
          json.set! alias_id.code_type do 
          json.id alias_id.id
          json.code alias_id.code
          end
      end
  end  
end