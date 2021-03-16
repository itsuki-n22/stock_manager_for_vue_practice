json.array! @products do |product|
  json.code product.code
  json.explain product.explain
  json.id product.id
  json.name product.name
  json.price product.price
  json.flag false
end