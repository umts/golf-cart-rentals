json.array!(@permissions) do |permission|
  json.extract! permission, :id
  json.url permission_url(permission, format: :json)
end
