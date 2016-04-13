require 'json'
class Inventory
  @base_uri = Rails.application.config.inventory_api_uri
  @get_headers = { 'Authorization' => "Token #{INVENTORY_API_KEY}" }
  @post_headers = @get_headers.merge('Content-Type' => 'application/json')

  def self.item_types
    response = HTTParty.get(@base_uri + 'item_types/', headers: @get_headers)
    handle_item_type_errors(response)
    JSON.parse(response.body)
  end

  def self.create_item_type(name, allowed_keys = [])
    response = HTTParty.post(@base_uri + 'item_types/',
                             body: { 'name' => name, 'allowed_keys' => allowed_keys }.to_json,
                             headers: @post_headers)
    handle_item_type_errors(response)
    JSON.parse(response.body)
  end

  def self.item_type(uuid)
    response = HTTParty.get(@base_uri + "item_types/#{uuid}", headers: @get_headers)
    handle_item_type_errors(response)
    JSON.parse(response.body)
  end

  def self.update_item_type(uuid, params)
    raise ArgumentError if params.empty?
    response = HTTParty.put(@base_uri + "item_types/#{uuid}", body: params.to_json, headers: @post_headers)
    handle_item_type_errors(response)
    JSON.parse(response.body)
  end

  def self.delete_item_type(uuid)
    response = HTTParty.delete(@base_uri + "item_types/#{uuid}", headers: @get_headers)
    handle_item_type_errors(response)
    # returns nothing on success
  end

  def self.create_item(item_type_uuid, name, reservable, metadata = {})
    response = HTTParty.post(@base_uri + 'items/',
                             body: { 'name' => name, 'item_type_uuid' => item_type_uuid, 'reservable' => reservable, 'data' => metadata }.to_json,
                             headers: @post_headers)
    handle_item_errors(response)
    JSON.parse(response.body)
  end

  def self.item(uuid)
    response = HTTParty.get(@base_uri + "items/#{uuid}", headers: @get_headers)
    handle_item_errors(response)
    JSON.parse(response.body)
  end

  def self.items_by_type(item_type_uuid)
    item_type(item_type_uuid)['items']
  end

  def self.update_item(uuid, params = {})
    raise ArgumentError if params.empty?
    response = HTTParty.put(@base_uri + "items/#{uuid}", body: params.to_json, headers: @post_headers)
    handle_item_errors(response)
    JSON.parse(response.body)
  end

  def self.delete_item(uuid)
    response = HTTParty.delete(@base_uri + "items/#{uuid}", headers: @get_headers)
    handle_item_errors(response)
    # returns nothing on success
  end

  def self.create_reservation(item_type, start_time, end_time)
    response = HTTParty.post(@base_uri + 'reservations/',
                             body: { 'item_type' => item_type, 'start_time' => start_time.iso8601, 'end_time' => end_time.iso8601 }.to_json,
                             headers: @post_headers)
    handle_reservation_errors(response)
    JSON.parse(response.body)
  end

  def self.reservation(uuid)
    response = HTTParty.get(@base_uri + "reservations/#{uuid}", headers: @get_headers)
    handle_reservation_errors(response)
    JSON.parse(response.body)
  end

  def self.reservations(start_time, end_time, item_type)
    body = { 'start_time' => start_time.iso8601, 'end_time' => end_time.iso8601, 'item_type' => item_type }
    response = HTTParty.get(@base_uri + 'reservations/', body: body.to_json, headers: @post_headers)
    handle_reservation_errors(response)
    JSON.parse(response.body)
  end

  # this sort of request only updates the reservations start and end time
  # (this is a constraint by the api)
  def self.update_reservation(uuid, params = {})
    raise ArgumentError if params.empty?
    params = params.with_indifferent_access
    params[:start_time] = params[:start_time].iso8601 if params[:start_time]
    params[:end_time] = params[:end_time].iso8601 if params[:end_time]
    response = HTTParty.put(@base_uri + "reservations/#{uuid}", body: { reservation: params }.to_json, headers: @post_headers)
    handle_reservation_errors(response)
    JSON.parse(response.body)
  end

  def self.update_reservation_start_time(uuid, start_time)
    update_reservation(uuid, reservation: { start_time: start_time })
  end

  def self.update_reservation_end_time(uuid, end_time)
    update_reservation(uuid, reservation: { end_time: end_time })
  end

  def self.update_reservation_data(uuid, params = {})
    raise ArgumentError if params.empty?
    response = HTTParty.post(@base_uri + "reservations/#{uuid}/update_item", body: params.to_json, headers: @post_headers)
    handle_reservation_errors(response)
    # returns nothing on success
  end

  def self.delete_reservation(uuid)
    response = HTTParty.delete(@base_uri + "reservations/#{uuid}", headers: @get_headers)
    handle_reservation_errors(response)
    # returns nothing on success
  end

  def self.handle_item_type_errors(response)
    raise AuthError, response.body if response.code == 401
    raise ItemTypeError, response.body if response.code == 422
    raise ItemTypeNotFound, response.body if response.code == 404
    raise InventoryError, response.body if response.code != 200 # handles stuff like a 500
  end

  def self.handle_item_errors(response)
    raise AuthError, response.body if response.code == 401
    raise ItemError, response.body if response.code == 422
    raise ItemNotFound, response.body if response.code == 404
    raise InventoryError, response.body if response.code != 200 # handles stuff like a 500
  end

  def self.handle_reservation_errors(response)
    raise AuthError, response.body if response.code == 401
    raise ReservationError, response.body if response.code == 422
    raise ReservationNotFound, response.body if response.code == 404
    raise InventoryError, response.body if response.code != 200
  end
end
