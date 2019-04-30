json.total_count @manifestations.total_count
json.results do
  json.array!(@manifestations) do |manifestation|
    json.partial!(manifestation)
  end
end
