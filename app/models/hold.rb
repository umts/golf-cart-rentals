# frozen_string_literal: true
class Hold < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :item

  after_save :check_conflicting_rentals

  validates :hold_reason, :item_id, :item_type_id, :start_time, :end_time, presence: true
  validates :end_time, date: { after: :start_time, message: 'must be after start time' }

  def check_conflicting_rentals
    conflicting_rentals = Rental.where('start_time >= :start_date AND end_time <= :end_date',
                                        start_date: start_time, end_date: end_time)
    conflicting_rentals.each { |r| replace_rental(r) } if conflicting_rentals.size > 0

    reserve_hold
  end

  def replace_rental(curr_rental)
    new_rental = Rental.create(item_type_id: curr_rental.item_type_id,
                               user_id: curr_rental.user_id, department_id: curr_rental.department_id,
                               start_time: curr_rental.start_time, end_time: curr_rental.end_time)

    curr_rental.cancel
    ReplacementMailer.replacement_email(curr_rental.user, this, curr_rental, new_rental)
  rescue
    errors.add(:item_id, ": failed to replace existing reservations for this item")
    ReplacementMailer.no_replacement_email(curr_rental.user, this, curr_rental)
  end

  def reserve_hold
    Inventory.update_item(item.uuid, reservable: false)
  end

  def unreserve_hold
    Inventory.update_item(item.uuid, reservable: true)
  end
end
