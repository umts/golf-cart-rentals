require 'json'
class Inventory
  @base_uri = 'http://localhost:3000/v1/' #Rails.application.config.inventory_api_uri
  @api_key = INVENTORY_API_KEY
  @post_headers = { 'Authorization' => "Token #{@api_key}", 'Content-Type' => 'application/json' }
  @get_headers = { 'Authorization' => "Token #{@api_key}" }

  def self.item_types
    response = HTTParty.get(@base_uri + 'item_types/', headers: @get_headers)
    fail AuthError if response.code == 401
    fail InventoryError if response.code != 200 # handles stuff like 422 and 500
    JSON.parse(response.body)
  end

  def self.create_item_type(name, allowed_keys = [])
    response = HTTParty.post(@base_uri + 'item_types/',
                             body: { 'name' => name, 'allowed_keys' => allowed_keys }.to_json,
                             headers: @post_headers)
    fail AuthError if response.code == 401
    fail InvalidItemTypeCreation if response.code == 422
    fail InventoryError if response.code != 200 # handles stuff like a 500
    JSON.parse(response.body)
  end

  def self.item_type(uuid)
    response = HTTParty.get(@base_uri + "item_types/#{uuid}", headers: @get_headers)
    fail AuthError if response.code == 401
    fail ItemTypeError if response.code == 422
    fail ItemTypeNotFound if response.code == 404
    fail InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.update_item_type(uuid, params)
    fail ArgumentError if params.empty?
    response = HTTParty.put(@base_uri + "item_types/#{uuid}", body: params.to_json, headers: @post_headers)
    fail AuthError if response.code == 401
    fail ItemTypeError if response.code == 422
    fail ItemTypeNotFound if response.code == 404
    fail InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.delete_item_type(uuid)
    response = HTTParty.delete(@base_uri + "item_types/#{uuid}", headers: @get_headers)
    fail AuthError if response.code == 401
    fail ItemTypeError if response.code == 422
    fail ItemTypeNotFound if response.code == 404
    fail InventoryError if response.code != 200
    # returns nothing on success
  end

  def self.create_item(item_type_uuid, name, reservable, metadata = {})
    response = HTTParty.post(@base_uri + 'items/',
                             body: { 'name' => name, 'item_type_uuid' => item_type_uuid, 'reservable' => reservable, 'data' => metadata }.to_json,
                             headers: @post_headers)
    fail AuthError if response.code == 401
    fail InvalidItemCreation if response.code == 422
    fail InventoryError if response.code != 200 # handles stuff like a 500
    JSON.parse(response.body)
  end

  def self.item(uuid)
    response = HTTParty.get(@base_uri + "items/#{uuid}", headers: @get_headers)
    fail AuthError if response.code == 401
    fail ItemError if response.code == 422
    fail ItemNotFound if response.code == 404
    fail InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.items_by_type(item_type_uuid)
    item_type(item_type_uuid)['items']
  end

  def self.update_item(uuid, params = {})
    fail ArgumentError if params.empty?
    response = HTTParty.put(@base_uri + "items/#{uuid}", body: params.to_json, headers: @post_headers)
    fail AuthError if response.code == 401
    fail ItemError if response.code == 422
    fail ItemNotFound if response.code == 404
    fail InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.delete_item(_uuid)
    # returns nothing on success
  end

  def self.create_reservation(item_type, start_time, end_time)
    JSON.parse("{\"id\": \"#{SecureRandom.uuid}\",
    \"start_time\": \"#{start_time}\",
    \"end_time\": \"#{end_time}\",
    \"item_type\": \"#{item_type}\",
    \"item\": \"Dummy Data\"}")
  end

  # maybe in the future add a few helper methods like update_start_time(uuid,start_time)
  def self.update_reservation(uuid, _key, _value)
    JSON.parse("{\"id\": \"#{uuid}\",
    \"start_time\": \"2016-02-16T15:30:00-05:00\",
    \"end_time\": \"2016-02-16T18:00:00-05:00\",
    \"item_type\": \"Apple\",
    \"item\": \"Dummy Data\"}")
  end

  def self.update_reservation_data(_key, _value)
    # returns nothing on success
  end

  # is this distinct enough from the singular method?
  def self.reservations(_start_time = 100.years.ago, _end_time = 100.years.from_now, _item_type)
    JSON.parse('[{"start_time": "2016-02-11T15:45:00-05:00", "end_time": "2016-02-11T21:00:00-05:00"},
                {"start_time": "2016-02-17T10:30:00-05:00", "end_time": "2016-02-19T21:00:00-05:00"}]')
  end

  def self.reservation(uuid)
    JSON.parse("{\"id\": \"#{uuid}\",
    \"start_time\": \"2016-02-16T15:30:00-05:00\",
    \"end_time\": \"2016-02-17T09:45:00-05:00\",
    \"item_type\": \"Apples\",
    \"item\": \"Granny Smith\"}")
  end

  def self.delete_reservation(_uuid)
    # returns nothing on success
  end
end
