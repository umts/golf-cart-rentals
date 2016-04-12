class Rental < ActiveRecord::Base
  include AASM

  belongs_to :user
  belongs_to :department
  belongs_to :item_type

  validates :reservation_id, presence: true, unless: :skip_reservation_validation
  validates :reservation_id, uniqueness: true
  validates :user_id, :start_date, :end_date, :item_type_id, presence: true
  validates :start_date, date: { after_or_equal_to: Time.zone.today, message: 'must be no earlier than today' }
  validates :end_date, date: { after_or_equal_to: :start_date, message: 'must be no earlier than today' }

  aasm column: :rental_status do
    state :reserved, initial: true
    state :checked_out
    state :checked_in
    state :inspected
    state :available
    state :canceled

    event :cancel do
      transitions from: :reserved, to: :canceled
    end

    event :pickup do
      transitions from: :reserved, to: :checked_out
      after do
        update(checked_out_at: Time.zone.now)
      end
    end

    event :return do
      transitions from: :checked_out, to: :checked_in
      after do
        update(checked_in_at: Time.zone.now)
      end
    end

    event :approve do
      transitions from: :checked_in, to: :inspected
    end

    event :process do
      transitions from: [:inspected, :canceled], to: :available
    end
  end

  def create_reservation
    return false unless mostly_valid?

    reservation = Inventory.create_reservation(item_type.name, start_date, start_date)
    if reservation
      self.reservation_id = reservation[:id]
    else
      errors.add(:base, 'Error occured in aggressive epsilon: real error or unable to create reservation')
    end

    save
  end

  def delete_reservation
    reservation = Inventory.delete_reservation(reservation_id)
    return true unless reservation

    errors.add(:base, 'Error occured in aggressive epsilon: unable to delete reservation')
    false
  end

  def mostly_valid?
    self.skip_reservation_validation = true
    is_valid = valid?
    self.skip_reservation_validation = false
    is_valid
  end

  def dates
    date_string = start_date.strftime('%a %m/%d/%Y')
    date_string += " - #{end_date.strftime('%a %m/%d/%Y')}" if start_date != end_date
    date_string
  end

  # private
  attr_accessor :skip_reservation_validation
end
