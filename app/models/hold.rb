# frozen_string_literal: true
class Hold < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :item

  after_save :check_conflicting_rentals
  before_destroy :unreserve_hold

  validates :hold_reason, :item_id, :item_type_id, :start_time, :end_time, presence: true
  validates :end_time, date: { after: :start_time, message: 'must be after start time' }

  def check_conflicting_rentals
    conflicting_rental = Rental.all.find { |r| r.item == item }
    replace_rental(conflicting_rental) if conflicting_rental
    reserve_hold
  end

  def replace_rental(curr_rental)
    new_rental = Rental.create(item_type_id: curr_rental.item_type_id,
                               user_id: curr_rental.user_id, department_id: curr_rental.department_id,
                               start_time: curr_rental.start_time, end_time: curr_rental.end_time)
    curr_rental.cancel
  end

  def reserve_hold
    Inventory.update_item(item.uuid, reservable: false)
  end

  def unreserve_hold
    Inventory.update_item(item.uuid, reservable: true)
  end
end
