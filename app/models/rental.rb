class Rental < ActiveRecord::Base
  include AASM
  include InventoryExceptions

  before_create :create_reservation
  before_destroy :delete_reservation

  belongs_to :user
  belongs_to :department
  belongs_to :item_type

  has_many :digital_signature

  validates :reservation_id, uniqueness: true
  validates :user_id, :start_time, :end_time, :item_type_id, presence: true
  validates :start_time, date: { after: Date.current, message: 'must be no earlier than today' }
  validates :end_time, date: { after: :start_time, message: 'must be after start' }

  alias_attribute :start_date, :start_time
  alias_attribute :end_date, :end_time

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
    return true if Rails.env.test? && reservation_id.present?
    return false unless valid? #check if the current rental object is valid or not
    
    begin
      reservation = Inventory.create_reservation(item_type.name, start_time, end_time)
      self.reservation_id = reservation[:uuid]
    rescue => error
      errors.add :base, error.inspect
      return false
    end
  end

  def delete_reservation
    return true if reservation_id.nil? # nothing to delete here
    return true if end_time < Time.current # deleting it is pointless, it wont inhibit new rentals and it will destroy a record.
    begin
      Inventory.delete_reservation(reservation_id)
      self.reservation_id = nil
    rescue => error
      errors.add(:base, error.inspect) && (return false)
    end
    true
  end

  def times
    start_time.strftime('%a %m/%d/%Y') + " - " + end_time.strftime('%a %m/%d/%Y')
  end
  alias dates times

end
