require 'json'
class Inventory < ActiveRecord::Base
#this class is all mocked for now
#in the future it should raise an exception if the api doesnt return a sucess status

  def self.item_types
    JSON.parse('[{"id": 100, "name": "Apples",
                "allowed_keys": ["flavor"],
                "items": [{"name": "Macintosh"},
                          {"name": "Granny Smith"}]}]')
  end

  def self.item_types_by_uuid(uuid)
    JSON.parse("{\"id\": #{uuid}, \"name\": \"Apples\",
                \"allowed_keys\": [\"flavor\"],
                \"items\": [{\"id\": 400, \"name": \"Macintosh\"},
                {\"id\": 401, \"name\": \"Granny Smith\"}]}")
  end

  def self.update_item_types()

  def self.create_reservation(item_type, start_time, end_time)
    JSON.parse("{\"id\": #{SecureRandom.uuid},
    \"start_time\": \"#{start_time}\",
    \"end_time\": \"#{end_time}\",
    \"item_type\": \"#{item_type}\",
    \"item\": \"Dummy Data\"}")
  end

  #maybe in the future add a few helper methods like update_start_time(uuid,start_time)
  def self.update_reservation(uuid, key, value)
    JSON.parse("{\"id\": #{uuid},
    \"start_time\": \"#{value}\",
    \"end_time\": \"2016-02-16T18:00:00-05:00\",
    \"item_type\": \"Apple\",
    \"item\": \"Dummy Data\"}")
  end

  def self.reservation(uuid)
    JSON.parse('{"id": 100,
    "start_time": "2016-02-16T15:30:00-05:00",
    "end_time": "2016-02-17T09:45:00-05:00",
    "item_type": "Apples",
    "item": "Granny Smith"}')
  end

  def self.delete_reservation(uuid)
    #returns nothing on success
  end
  
  def self.update_reservation_item(key, value)
    #returns nothing
  end
  #is this distinct enough from the singular method?
  def self.reservations(start_time,end_time, item_type)
    JSON.parse('[{"start_time": "2016-02-11T15:45:00-05:00", "end_time": "2016-02-11T21:00:00-05:00"},
                {"start_time": "2016-02-17T10:30:00-05:00", "end_time": "2016-02-19T21:00:00-05:00"}]')
  end
end
