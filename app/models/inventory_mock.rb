require 'json'
class InventoryMock
  @base_uri = Rails.application.config.inventory_api_uri

  def self.mock_exception
    raise InventoryError, 'test'
  end

  def self.item_types
    JSON.parse('[{"id": 100, "name": "Apples",
               "allowed_keys": ["flavor"],
               "items": [{"name": "Macintosh"},
                        {"name": "Granny Smith"}]}]')
  end

  def self.item_type(uuid)
    JSON.parse("{\"id\": \"#{uuid}\", \"name\": \"Apples\",
                \"allowed_keys\": [\"flavor\"],
                \"items\": [{\"id\": 400, \"name\": \"Macintosh\"},
                {\"id\": 401, \"name\": \"Granny Smith\"}]}")
  end

  def self.update_item_type(uuid, _key, _value)
    JSON.parse("{\"id\": \"#{uuid}\", \"name\": \"Apples\",
                \"allowed_keys\": [\"flavor\"],
                \"items\": [{\"name\": \"Macintosh\"},
                            {\"name\": \"Granny Smith\"}]}")
  end

  def self.delete_item_type(_uuid)
    # returns nothing on success
  end

  def self.create_item_type(name, allowed_keys = [])
    JSON.parse("{\"id\": \"#{SecureRandom.uuid}\", \"name\": \"#{name}\", \"allowed_keys\": #{allowed_keys},
                \"items\": []}")
  end

  def self.create_item(name, item_type_uuid, metadata = {})
    JSON.parse("{\"id\": 300, \"name\": \"#{name}\", \"item_type_id\": \"#{item_type_uuid}\", \"data\": #{metadata}}")
  end

  def self.items_by_type(item_type_uuid)
    JSON.parse("[{\"id\": 300, \"name\": \"Awesome new couch\", \"item_type_id\": \"#{item_type_uuid}\", \"data\": {}},
                {\"id\": 301, \"name\": \"Cool leather futon\", \"item_type_id\": \"#{item_type_uuid}\", \"data\": {\"texture\": \"leather\"}}]")
  end

  def self.item(uuid)
    JSON.parse("{\"id\": \"#{uuid}\", \"name\": \"Awesome new couch\", \"item_type_id\": 101, \"data\": {}}")
  end

  def self.update_item(uuid, _key, _value)
    JSON.parse("{\"id\": \"#{uuid}\", \"name\": \"Awesome new couch\", \"item_type_id\": 101, \"data\": {}}")
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

  def self.update_reservation_data(_key, _value)
    # returns nothing on success
  end

  # is this distinct enough from the singular method?
  def self.reservations(_start_time = 100.years.ago, _end_time = 100.years.from_now, _item_type)
    JSON.parse('[{"start_time": "2016-02-11T15:45:00-05:00", "end_time": "2016-02-11T21:00:00-05:00"},
                {"start_time": "2016-02-17T10:30:00-05:00", "end_time": "2016-02-19T21:00:00-05:00"}]')
  end
end
