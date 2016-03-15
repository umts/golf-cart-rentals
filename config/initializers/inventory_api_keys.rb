yaml = 'config/inventory_api_keys.yaml'
if File.exist?(yaml)
  require "erb"
  all_secrets = YAML.load(ERB.new(IO.read(yaml)).result) || {}
  env_secrets = all_secrets[Rails.env]
  secrets.merge!(env_secrets.symbolize_keys) if env_secrets
end
