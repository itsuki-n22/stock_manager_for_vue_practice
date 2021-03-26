require 'csv'

CSV.generate do |csv|
  column_names = %w(code name explain price)
  csv << column_names
  @products.each do |product|
    column_values = [
      product.code,
      product.name,
      product.explain,
      product.price
    ]
    csv << column_values
  end
end
