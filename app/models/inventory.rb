require 'json'
class Inventory
  @base_uri = 'http://localhost:3000/v1/' # Rails.application.config.inventory_api_uri
  @api_key = INVENTORY_API_KEY
  @post_headers = { 'Authorization' => "Token #{@api_key}", 'Content-Type' => 'application/json' }
  @get_headers = { 'Authorization' => "Token #{@api_key}" }

  def self.item_types
    response = HTTParty.get(@base_uri + 'item_types/', headers: @get_headers)
    raise AuthError if response.code == 401
    raise InventoryError if response.code != 200 # handles stuff like 422 and 500
    JSON.parse(response.body)
  end

  def self.create_item_type(name, allowed_keys = [])
    response = HTTParty.post(@base_uri + 'item_types/',
                             body: { 'name' => name, 'allowed_keys' => allowed_keys }.to_json,
                             headers: @post_headers)
    raise AuthError if response.code == 401
    raise InvalidItemTypeCreation if response.code == 422
    raise InventoryError if response.code != 200 # handles stuff like a 500
    JSON.parse(response.body)
  end

  def self.item_type(uuid)
    response = HTTParty.get(@base_uri + "item_types/#{uuid}", headers: @get_headers)
    raise AuthError if response.code == 401
    raise ItemTypeError if response.code == 422
    raise ItemTypeNotFound if response.code == 404
    raise InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.update_item_type(uuid, params)
    raise ArgumentError if params.empty?
    response = HTTParty.put(@base_uri + "item_types/#{uuid}", body: params.to_json, headers: @post_headers)
    raise AuthError if response.code == 401
    raise ItemTypeError if response.code == 422
    raise ItemTypeNotFound if response.code == 404
    raise InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.delete_item_type(uuid)
    response = HTTParty.delete(@base_uri + "item_types/#{uuid}", headers: @get_headers)
    raise AuthError if response.code == 401
    raise ItemTypeError if response.code == 422
    raise ItemTypeNotFound if response.code == 404
    raise InventoryError if response.code != 200
    # returns nothing on success
  end

  def self.create_item(item_type_uuid, name, reservable, metadata = {})
    response = HTTParty.post(@base_uri + 'items/',
                             body: { 'name' => name, 'item_type_uuid' => item_type_uuid, 'reservable' => reservable, 'data' => metadata }.to_json,
                             headers: @post_headers)
    raise AuthError if response.code == 401
    raise InvalidItemCreation if response.code == 422
    raise InventoryError if response.code != 200 # handles stuff like a 500
    JSON.parse(response.body)
  end

  def self.item(uuid)
    response = HTTParty.get(@base_uri + "items/#{uuid}", headers: @get_headers)
    raise AuthError if response.code == 401
    raise ItemError if response.code == 422
    raise ItemNotFound if response.code == 404
    raise InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.items_by_type(item_type_uuid)
    item_type(item_type_uuid)['items']
  end

  def self.update_item(uuid, params = {})
    raise ArgumentError if params.empty?
    response = HTTParty.put(@base_uri + "items/#{uuid}", body: params.to_json, headers: @post_headers)
    raise AuthError if response.code == 401
    raise ItemError if response.code == 422
    raise ItemNotFound if response.code == 404
    raise InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.delete_item(uuid)
    response = HTTParty.delete(@base_uri + "items/#{uuid}", headers: @get_headers)
    raise AuthError if response.code == 401
    raise ItemError if response.code == 422
    raise ItemNotFound if response.code == 404
    raise InventoryError if response.code != 200
    # returns nothing on success
  end

  def self.create_reservation(item_type, start_time, end_time)
    response = HTTParty.post(@base_uri + 'reservations/',
                             body: { 'item_type' => item_type, 'start_time' => start_time, 'end_time' => end_time }.to_json,
                             headers: @post_headers)
    raise AuthError if response.code == 401
    raise InvalidReservationCreation if response.code == 422
    raise InventoryError if response.code != 200 # handles stuff like a 500
    JSON.parse(response.body)
  end

  def self.reservation(uuid)
    response = HTTParty.get(@base_uri + "reservations/#{uuid}", headers: @get_headers)
    raise AuthError if response.code == 401
    raise ReservationError if response.code == 422
    raise ReservationNotFound if response.code == 404
    raise InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  # is this distinct enough from the singular method?
  def self.reservations(start_time, end_time, item_type)
    body = {'start_time' => start_time, 'end_time' => end_time, 'item_type' => item_type}
    response = HTTParty.get(@base_uri + "reservations/", body: body.to_json, headers: @post_headers)
    raise AuthError if response.code == 401
    raise ReservationError if response.code == 422
    raise ReservationNotFound if response.code == 404
    raise InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  # maybe in the future add a few helper methods like update_start_time(uuid,start_time)
  def self.update_reservation(uuid, params = {})
    raise ArgumentError if params.empty?
    response = HTTParty.put(@base_uri + "reservations/#{uuid}", body: params.to_json, headers: @post_headers)
    raise AuthError if response.code == 401
    raise ReservationError if response.code == 422
    raise ReservationNotFound if response.code == 404
    raise InventoryError if response.code != 200
    JSON.parse(response.body)
  end

  def self.update_reservation_data(_key, _value)
    # returns nothing on success
  end

  def self.delete_reservation(_uuid)
    # returns nothing on success
  end
end
