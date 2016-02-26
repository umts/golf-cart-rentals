json.array!(@item_types) do |item_type|
  json.extract! item_type, :id, :name
  json.url item_type_url(item_type, format: :json)
end
