require 'json'
include InventoryExceptions

class Inventory::Client
  def initialize
    @base_uri = Rails.application.config.inventory_api_uri
    @get_headers = { 'Authorization' => "Token #{INVENTORY_API_KEY}" }
    @post_headers = @get_headers.merge('Content-Type' => 'application/json')
  end


  def item_types
    response = HTTParty.get(@base_uri + 'item_types/', headers: @get_headers)
    #handle_item_type_errors(response)
    Inventory::Collection.new(Inventory::ItemTipe, JSON.parse(response.body))
  end
end
