yaml = 'config/inventory_api_keys.yml'
if File.exist?(yaml)
  require "erb"
  all_secrets = YAML.load(ERB.new(IO.read(yaml)).result) || {}
  env_secrets = all_secrets[Rails.env]
  INVENTORY_API_KEY = env_secrets.symbolize_keys[:inventory_api_key] if env_secrets
end
