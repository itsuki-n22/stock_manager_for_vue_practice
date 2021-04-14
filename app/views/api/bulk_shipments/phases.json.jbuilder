json.phases do
  json.array! BulkShipment.phases do |phase|
    json.name phase[0]
    json.id phase[1]
  end
end