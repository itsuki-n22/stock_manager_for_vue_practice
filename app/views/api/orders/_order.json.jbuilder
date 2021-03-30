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
