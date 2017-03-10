# frozen_string_literal: true
class Rental < ActiveRecord::Base
  include AASM
  include InventoryExceptions

  has_many :incurred_incidentals, dependent: :destroy

  has_many :financial_transactions
  has_one :financial_transaction, as: :transactable

  after_create :create_financial_transaction

  belongs_to :creator, class_name: User
  belongs_to :renter, class_name: User

  belongs_to :department
  belongs_to :item_type
  belongs_to :item

  has_many :digital_signature

  validates :reservation_id, uniqueness: true
  validates :renter, :creator, :start_time, :end_time, :item_type, :department, presence: true
  validates :start_time, date: { after: Date.current, message: 'must be no earlier than today' }
  validates :end_time, date: { after: :start_time, message: 'must be after start' }

  alias_attribute :start_date, :start_time
  alias_attribute :end_date, :end_time

  scope :upcoming_rentals, -> { reserved.where('start_time <= ? AND end_time >= ?', DateTime.current.next_day, DateTime.current) }
  scope :all_future_rentals, -> { reserved.where('end_time >= ?', DateTime.current) }
  scope :no_show_rentals, -> { reserved.where('end_time < ?', DateTime.current) }
  scope :inactive_rentals, -> { where(rental_status: %w(canceled dropped_off)) }
  scope :rented_by, ->(user) { where(renter_id: user) }
  scope :created_by, ->(user) { where(creator_id: user) }
  scope :with_balance_due, -> { Rental.where id: Rental.select { |rental| rental.balance.positive? }.collect(&:id) }
  scope :with_balance_over, ->(min) { Rental.where id: Rental.select { |rental| rental.balance >= min }.collect(&:id) }

  aasm column: :rental_status do
    state :reserved, initial: true
    state :picked_up
    state :dropped_off
    state :inspected
    state :available
    state :canceled

    event :cancel do
      transitions from: :reserved, to: :canceled
      after do
        financial_transaction.zero_balance 'Canceling a reservation and zero-ing balance'
      end
    end

    event :pickup do
      transitions from: :reserved, to: :picked_up
      after do
        update(picked_up_at: Time.zone.now)
      end
    end

    event :drop_off do
      transitions from: :picked_up, to: :dropped_off
      after do
        update(dropped_off_at: Time.zone.now)
      end
    end

    event :approve do
      transitions from: :dropped_off, to: :inspected
    end

    event :process do
      transitions from: [:inspected, :canceled], to: :available
    end

    event :process_no_show do
      transitions from: :reserved, to: :canceled
      after do
        update(dropped_off_at: nil, start_time: Time.zone.now.beginning_of_day, end_time: Time.zone.now.end_of_day)
      end
    end
  end

  def create_reservation
    return false unless valid? # check if the current rental object is valid or not
    begin
      reservation = Inventory.create_reservation(item_type.name, start_time, end_time)
      self.reservation_id = reservation[:uuid]
      self.item = Item.find_by(name: reservation[:item][:name])
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
      '#0092ff'
    when 'picked_up'
      '#f7ff76'
    when 'dropped_off'
      '#09ff00'
    when 'canceled'
      '#ff0000'
    else
      '#000000' # black signifies a non event status
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

  def sum_charges
    financial_transactions.where.not(transactable_type: Payment.name).sum(:amount)
  end

  def sum_payments
    financial_transactions.where(transactable_type: Payment.name).sum(:amount)
  end

  def balance
    sum_charges - sum_payments
  end

  # this method seems really inefficient
  # def self.with_balance_due
  # Rental.select { |x| x.balance > 0 }
  # end

  # private
  attr_accessor :skip_reservation_validation

  def self.cost(start_time, end_time, item_type)
    return 0 if start_time > end_time
    rental_duration = (end_time.to_date - start_time.to_date).to_i
    # Do not charge for 1/7 days in a rental.
    days_to_charge_for = rental_duration - (rental_duration / 7)
    (days_to_charge_for * item_type.fee_per_day) + item_type.base_fee
  end

  def create_financial_transaction
    rental_amount = Rental.cost(start_time.to_date, end_time.to_date, item_type)
    FinancialTransaction.create rental: self, amount: rental_amount, transactable_type: self.class, transactable_id: id
  end
end
