class Rental < ActiveRecord::Base
  include AASM
  include InventoryExceptions

  has_many :incurred_incidentals, dependent: :destroy

  has_many :financial_transactions
  has_one :financial_transaction, as: :transactable

  before_create :create_reservation
  before_destroy :delete_reservation
  after_create :create_financial_transaction

  belongs_to :user
  belongs_to :department
  belongs_to :item_type
  belongs_to :item

  has_many :digital_signature

  validates :reservation_id, uniqueness: true
  validates :user_id, :start_time, :end_time, :item_type_id, :department_id, presence: true
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
    return false unless valid? # check if the current rental object is valid or not
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

  def basic_info
    "#{item_type.name}:(#{start_date.to_date} -> #{end_date.to_date})"
  end

  def times
    start_time.strftime('%a %m/%d/%Y') + ' - ' + end_time.strftime('%a %m/%d/%Y')
  end
  alias dates times

  def event_name
    "#{item_type.name}(#{item_type.id}) - Rental ID: #{id}"
  end

  def event_status_color
    case rental_status
    when 'reserved'
      return '#0092ff'
    when 'checked_out'
      return '#f7ff76'
    when 'checked_in'
      return '#09ff00'
    else
      return '#000000' # black signifies a non event status
    end
  end

  def self.to_json_reservations
    arr = all.each_with_object([]) do |rental, list|
      list << { title: rental.event_name,
                start: rental.start_time,
                end: rental.end_time,
                color: rental.event_status_color,
                textColor: '#000000',
                url: Rails.application.routes.url_helpers.rental_path(rental.id) }
    end
    arr
  end

  def sum_amount
    financial_transactions.sum(:amount)
  end

  # private
  attr_accessor :skip_reservation_validation

  def create_financial_transaction
    rental_amount = ((end_time.to_date - start_time.to_date).to_i * item_type.fee_per_day) + item_type.base_fee

    FinancialTransaction.create rental: self, amount: rental_amount, transactable_type: self.class, transactable_id: id
  end
end
