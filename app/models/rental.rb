# frozen_string_literal: true
class Rental < ActiveRecord::Base
  include AASM
  include InventoryExceptions
  include ApplicationHelper

  # will skip financial transactions if we plan to create manual pricing
  attr_accessor :skip_financial_transactions

  # create reservation unless it has already been created
  before_save :create_reservations, unless: proc { |rental| rental.reservation_ids.any? }

  after_create :create_financial_transaction, unless: :skip_financial_transactions

  # unreserve the items
  before_destroy :delete_reservations

  belongs_to :creator, class_name: 'User'
  belongs_to :renter, class_name: 'User'

  has_one :financial_transaction, as: :transactable
  has_many :financial_transactions
  has_many :incurred_incidentals, dependent: :destroy
  has_many :rentals_items, dependent: :destroy, inverse_of: :rental
  has_many :items, through: :rentals_items
  has_many :item_types, through: :rentals_items

  accepts_nested_attributes_for :rentals_items

  # clean phone numbers before saving them, if necessary
  before_validation :sanitize_phone_numbers

  validate :renter_is_assignable
  validates :renter, :creator, :start_time, :end_time, :rentals_items, presence: true
  validates :start_time, :end_time, date: { after: proc { Date.current },
                                            message: 'must be after current date' }, unless: :persisted?
  validates :end_time, date: { after: :start_time, message: 'must be after start' }

  def renter_is_assignable
    return unless renter && creator # will be validated elsewhere, dont add an error twice
    if creator.assignable_renters.exclude? renter
      errors.add :renter, 'must have permission to assign'
    end
  end

  alias_attribute :start_date, :start_time
  alias_attribute :end_date, :end_time

  scope :upcoming_rentals, -> { reserved.where('start_time <= ? AND end_time >= ?', DateTime.current.next_day, DateTime.current) }
  scope :all_future_rentals, -> { reserved.where('end_time >= ?', DateTime.current) }
  scope :no_show_rentals, -> { reserved.where('end_time < ?', DateTime.current) }
  scope :inactive_rentals, -> { where(rental_status: %w(canceled dropped_off)) }
  scope :rented_by, ->(user) { where(renter_id: user) }
  scope :created_by, ->(user) { where(creator_id: user) }

  # if these queries ever become a problem this would be faster, i think a cross apply or something like that would probably be even faster.
  # select * from rentals where
  #  (select coalesce(sum(amount),0) from financial_transactions where
  #    rental_id=rentals.id and not (transactable_type='Payment' or transactable_type='Cancelation')) -
  #  (select coalesce(sum(amount),0) from financial_transactions where
  #    rental_id=rentals.id and (transactable_type='Payment' or transactable_type='Cancelation')) > min
  scope :with_balance_due, -> { Rental.where id: Rental.select { |rental| rental.balance.positive? }.collect(&:id) }
  scope :with_balance_over, ->(min) { Rental.where id: Rental.select { |rental| rental.balance > min }.collect(&:id) }

  delegate :payments, to: :financial_transactions
  delegate :department, to: :renter

  def reservations
    rentals_items.collect(&:reservation_id)
  end; alias reservation_ids reservations

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
        # Canceling a reservation and zero-ing balance
        FinancialTransaction.create amount: balance, transactable_type: Cancelation.name, rental: self
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

  # Note, rspec will mock this so we wont communicate with the api
  def create_reservations
    # if we fail half way through creating reservations we should roll them all back
    created_reservations = []
    begin
      raise RecordInvalid, 'Rental invalid' unless valid?
      rentals_items.each do |ri|
        raise RecordInvalid, 'Rental item is invalid' unless ri.valid? # check if the current rental item is valid

        reservation = Inventory.create_reservation(ri.item_type.name, start_time, end_time)
        raise 'Reservation UUID was not present in response.' unless reservation[:uuid].present?

        ri.reservation_id = reservation[:uuid]
        created_reservations << reservation[:uuid]
        ri.item = Item.find_by(name: reservation[:item][:name])
      end
    rescue => error
      # roll back the rentals we got partially through creating
      failed_roll_back = false
      created_reservations.each do |uuid|
        # remove reservation from RentalsItem
        rental_item = rentals_items.to_a.find { |ri| ri.reservation_id == uuid }
        if rental_item.present?
          rental_item.reservation_id = nil
        else
          failed_roll_back = true
          errors.add :base, "Failed to find associated rentals item when rolling back reservation (uuid #{uuid})"
        end

        # remove reservation from api
        unless delete_reservation(uuid)
          errors.add :base, "Failed to delete reservations from inventory api (uuid #{uuid})"
          failed_roll_back = true
        end
      end

      errors.add :base, "Reservations #{'partially' if failed_roll_back} rolled back " + error.inspect
      throw :abort
    end
  end

  def delete_reservations
    return true if end_time < Time.current # deleting it is pointless, it wont inhibit new rentals and it will destroy a record.
    rentals_items.each do |ri|
      next if ri.reservation_id.nil? # nothing to delete here
      errors.add(:rentals_items, "Failed to delete reservation (uuid #{ri.reservation_id})") unless delete_reservation(ri.reservation_id)
      ri.reservation_id = nil
    end
    throw(:abort) if errors.any? # abort a #destroy
    errors.empty?
  end

  def delete_reservation(uuid)
    Inventory.delete_reservation(uuid) # will throw errors if it fails
  rescue
    return false
  end

  # join reservation ids togeather as a comma separated str
  def str_reservation_ids(trnc = 0)
    stringulize_arr(reservation_ids, :itself, false, trnc)
  end

  # join item names togeather as a comma separated str
  def str_items(with_ids = false, trnc = 0)
    stringulize_arr(items, :name, with_ids, trnc)
  end

  # join item type names togeather as a comma separated str
  def str_item_types(with_ids = false, trnc = 0)
    stringulize_arr(item_types, :name, with_ids, trnc)
  end

  def basic_info
    "#{str_item_types}:(#{start_date.to_date} -> #{end_date.to_date})"
  end

  def times
    start_time.strftime('%a %m/%d/%Y') + ' - ' + end_time.strftime('%a %m/%d/%Y')
  end
  alias dates times

  def event_name
    "#{str_item_types(true)} - Rental ID: #{id}"
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
    financial_transactions.where.not('transactable_type=? OR transactable_type=?', Payment.name, Cancelation.name).sum(:amount)
  end

  def sum_payments
    financial_transactions.where('transactable_type=? OR transactable_type=?', Payment.name, Cancelation.name).sum(:amount)
  end

  def balance
    sum_charges - sum_payments
  end

  def duration
    (end_time.to_date - start_time.to_date).to_i + 1
  end

  def create_financial_transaction
    # create financial transactions for all the rentals
    rentals_items.each do |ri|
      rental_amount = ri.item_type.cost(start_time.to_date, end_time.to_date)
      FinancialTransaction.create rental: self, amount: rental_amount, transactable_type: RentalsItem.name, transactable_id: ri.id
    end
  end

  def cost
    rentals_items.sum { |ri| ri.item_type.cost(start_time.to_date, end_time.to_date) }
  end

  private

  def sanitize_phone_numbers
    if attribute_present? 'pickup_phone_number'
      self.pickup_phone_number = pickup_phone_number.gsub(/\W/, '')
    end

    if attribute_present? 'dropoff_phone_number'
      self.dropoff_phone_number = dropoff_phone_number.gsub(/\W/, '')
    end
  end
end
