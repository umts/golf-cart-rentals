# frozen_string_literal: true
class Reservation < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :item

  before_create :create_api_reservation
  before_update :update_api_reservation
  before_destroy :destroy_api_reservation

  validates :reservation_id, uniqueness: true
  validates :reservation_type, :end_time, :item_type_id, presence: true
  validates :end_time, date: { after: :start_time, message: 'must be after start time' }

  def create_api_reservation
    return false unless valid?
    begin
      reservation = Inventory.create_reservation(item_type.name, start_time, end_time)
      self.reservation_id = reservation[:uuid]
      self.item = Item.find_by(name: reservation[:item])
    rescue => error
      errors.add :base, error.inspect
      return false
    end
    true
  end

  def update_api_reservation
    if start_time <= end_time
      Inventory.update_reservation_start_time(reservation_id, start_time)
      Inventory.update_reservation_end_time(reservation_id, end_time)
      return true
    end
    false
  end

  def destroy_api_reservation
    return true if reservation_id.nil?
    begin
      Inventory.delete_reservation(reservation_id)
      self.reservation_id = nil
    rescue => error
      errors.add(:base, error.inspect) && (return false)
      return false
    end
    true
  end
end
