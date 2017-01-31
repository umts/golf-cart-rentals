# frozen_string_literal: true
class Hold < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :item

  # maybe destroy the damage, maybe not, that will destroy the incurred_incidental as well
  has_one :damage # , dependent: :destroy

  validates :hold_reason, :item_id, :item_type_id, :start_time, :end_time, presence: true
  validates :start_time, :end_time, date: { after: Date.current, message: 'must be after current date. ' }
  validates :end_time, date: { after: :start_time, message: 'must be after start time' }

  def check_conflicting_rentals
    conflicting_rentals = Rental.where('start_time >= :hold_start_time AND end_time <= :hold_end_time',
                                       hold_start_time: start_time,
                                       hold_end_time: end_time)
    conflicting_rentals.each { |r| replace_rental(r) } unless conflicting_rentals.empty?
    start_hold
  end

  def replace_rental(curr_rental)
    new_rental = Rental.create(item_type_id: curr_rental.item_type_id,
                               user_id: curr_rental.renter_id, department_id: curr_rental.department_id,
                               start_time: curr_rental.start_time, end_time: curr_rental.end_time)

    curr_rental.cancel
    curr_rental.save
    ReplacementMailer.replacement_email(curr_rental.renter, self, curr_rental, new_rental).deliver_now
  rescue
    errors.add(:item_id, ': failed to replace existing rentals for this item')
    ReplacementMailer.no_replacement_email(curr_rental.renter, self, curr_rental).deliver_now
  end

  def start_hold
    Inventory.update_item(item.uuid, reservable: false)
  rescue
    errors.add(:reservable, 'error occurred while creating Hold')
  end

  def lift_hold
    Inventory.update_item(item.uuid, reservable: true)
    return true
  rescue
    errors.add(:reservable, 'error occurred while lifting hold')
    return false
  end
end
