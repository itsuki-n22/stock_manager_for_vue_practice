json.extract! bulk_shipment, :id, :arrived_date, :delivery_agent_id, :delivery_charge,
    :from, :name, :phase, :ship_date, :to, :tracking_number

json.flag false
json.ship_date_flag = false
json.arrived_date_flag = false
#if order.memo == nil
#  json.memo do
#    json.content ""
#  end
#else
#  json.memo order.memo, :id, :content
#end
#json.platform order.platform, :id, :name, :url
json.shipping_items do 
  json.array! bulk_shipment.bulk_shipping_items do |shipping_item|
    product = Product.find(shipping_item.product_id)
    json.product_id product.code
    json.first_image_url product.first_image_url
    json.quantity shipping_item.quantity
    json.price shipping_item.price
    json.id shipping_item.id
  end
end
