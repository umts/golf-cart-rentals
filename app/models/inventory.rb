class Inventory
  def self.method_missing(method_name, *args, &block)
    AggressiveInventory.configure do |config|
      config.base_uri = Rails.application.config.inventory_api_uri
      config.auth_token = INVENTORY_API_KEY
    end
    client = AggressiveInventory::Legacy::Client.new

    if client.respond_to?(method_name)
      client.send(method_name, *args, &block)
    else
      super
    end
  end

  def self.respond_to?(method_name, include_private=false)
    AggressiveInventory.configure do |config|
      config.base_uri = Rails.application.config.inventory_api_uri
      config.auth_token = INVENTORY_API_KEY
    end
    client = AggressiveInventory::Legacy::Client.new

    if client.respond_to?(method_name, include_private)
      true
    else
      super
    end
  end

end
