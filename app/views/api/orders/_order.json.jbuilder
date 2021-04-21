json.extract! order, :order_number, :customer_name, :postal_code, :prefecture,
    :phone_country, :phone_number, :delivery_charge, :status, :address, :id


if order.memo == nil
  json.memo do
    json.content ""
  end
else
  json.memo order.memo, :id, :content
end
json.flag false
json.platform order.platform, :id, :name, :url
json.shipping_items do 
  json.array! order.shipping_items.order(:created_at) do |shipping_item|
    product = Product.find(shipping_item.product_id)
    json.product_id product.code
    json.first_image_url product.first_image_url
    json.quantity shipping_item.quantity
    json.tracking_number shipping_item.tracking_number
    json.delivery_agent shipping_item.delivery_agent
    json.is_sent shipping_item.is_sent
    json.price shipping_item.price
    json.from shipping_item.from
    json.to shipping_item.to
    json.id shipping_item.id
    json.flag false
  end
end
