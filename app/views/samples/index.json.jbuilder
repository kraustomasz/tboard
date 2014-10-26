json.array!(@samples) do |sample|
  json.extract! sample, :id, :field1, :field2
  json.url sample_url(sample, format: :json)
end
