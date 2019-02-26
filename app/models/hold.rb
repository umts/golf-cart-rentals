# frozen_string_literal: true
class Hold < ActiveRecord::Base
  belongs_to :item_type
  belongs_to :item

  # maybe destroy the damage, maybe not, that will destroy the incurred_incidental as well
  has_one :damage # , dependent: :destroy

  validates :hold_reason, :start_time, :end_time, presence: true
  validates :start_time, :end_time, date: { after: proc { Date.current },
                                            message: 'must be after current date.' }, unless: :persisted?
  validates :end_time, date: { after: :start_time, message: 'must be after start time' }

  # hold lasts between dates inclusive
  before_save do |hold|
    hold.start_time = hold.start_time.beginning_of_day
    hold.end_time = hold.end_time.end_of_day
  end

  def handle_conflicting_rentals
    # if rental falls between data range of our hold
    # only reserved but not picked up
    conflicting_rentals = Rental.reserved.joins(:rentals_items)
                                .where('start_time <= :hold_end_time AND end_time >= :hold_start_time AND rentals_items.item_id = :hold_item_id',
                                       hold_start_time: start_time, hold_end_time: end_time, hold_item_id: item.id)
    # Rental.where('start_time <= ? AND end_time >= ?', end_time, start_time) also works
    conflicting_rentals.each { |r| replace_rental(r) } unless conflicting_rentals.empty?
    start_hold
  end

  def replace_rental(curr_rental)
    new_rental = Rental.new(rentals_items_attributes: (curr_rental.item_types.map { |x| { item_type: x } }), creator: curr_rental.creator,
                            renter: curr_rental.renter, start_time: curr_rental.start_time, end_time: curr_rental.end_time)
    new_rental.save!
    curr_rental.cancel!
    ReplacementMailer.replacement_email(curr_rental.renter, self, curr_rental, new_rental).deliver_now
  rescue => err
    errors.add(:rentals_items, ': failed to replace existing rentals for this item ' + err.message)
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

  def conflicting_ongoing_rental
    # it couldnt be possible that the same item has already been picked up twice under the same rental
    Rental.picked_up.joins('INNER JOIN rentals_items ON rentals_items.rental_id = rentals.id')
          .find_by('start_time <= :hold_end_time AND end_time >= :hold_start_time AND rentals_items.item_id = :hold_item_id',
                   hold_start_time: start_time, hold_end_time: end_time, hold_item_id: item.id)
  end
end
