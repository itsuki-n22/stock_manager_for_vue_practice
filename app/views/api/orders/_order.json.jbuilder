json.extract! order, :order_number, :customer_name, :postal_code, :prefecture,
    :phone_country, :phone_number, :delivery_charge, :platform, :status, :address, :id

if order.memo == nil
  json.memo do
    json.content ""
  end
else
  json.memo order.memo, :id, :content
end
json.flag false
json.shipping_items do 
  json.array! order.shipping_items do |shipping_item|
    product = Product.find(shipping_item.product_id)
    json.product_id product.code
    json.first_image_url product.first_image_url
    json.quantity shipping_item.quantity
    json.price shipping_item.price
    json.id shipping_item.id
  end
end
