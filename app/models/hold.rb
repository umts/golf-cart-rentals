# frozen_string_literal: true
class Hold < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :item

  # before v. after?
  after_create :reserve_hold
  after_update :reserve_hold

  validates :hold_reason, :item_id, :item_type_id, :start_time, :end_time, presence: true
  validates :end_time, date: { after: :start_time, message: 'must be after start time' }

  def check_conflicting_rentals
    if Rental.all.any? { |r| r.item == item }
      replace_rental
    else
      reserve_hold
    end
  end

  def replace_rental
    rental = Rental.all.find { |r| r.item == item }

  end

  def reserve_hold
    Inventory.update_item(item.uuid, start_time: start_time, end_time: end_time, reservable: false)
  end

end
