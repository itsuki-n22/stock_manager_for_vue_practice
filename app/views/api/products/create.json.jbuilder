json.code @product.code
json.name @product.name
json.price @product.price
json.flag false
json.id @product.id
json.first_image_url @product.first_image_url
@product.stocks.each do |stock|
    json.stocks do 
        json.set! stock.place do 
        json.id stock.id
        json.quantity stock.quantity
        end
    end
end  
json.image_urls product.image_urls