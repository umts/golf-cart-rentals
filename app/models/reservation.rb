class Reservation < ActiveRecord::Base
  belongs_to :item_type

  def create_reservation(end_time)
    #check current reservation validation
    return false unless valid?
    begin
      reservation = Inventory.create_reservation(item_type.name, DateTime.current, end_time)
      self.reservation_id = reservation[:uuid]
    rescue => error
      errors.add :base, error.inspect
      return false
    end
  end

  def get_api_reservation
    return Inventory.reservation(this.reservation_id)
  end

  def update_api_reservation_end_time(end_time)
    api_reservation = Inventory.reservation(reservation_id)
    if (api_reservation[:start_time] <= end_time)
      Inventory.update_reservation_end_time(reservation_id, end_time)
      return true
    end
    return false
  end
end
