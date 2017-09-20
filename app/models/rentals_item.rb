class RentalsItem < ActiveRecord::Base
  has_paper_trail
  # use inverse of so we can create this with rental blank at first
  belongs_to :rental, inverse_of: :rentals_items
  belongs_to :item
  belongs_to :item_type
  validates :rental, :item, :item_type, presence: true
  validates :reservation_id, uniqueness: true, allow_nil: true

  alias_attribute :reservation, :reservation_id

  # create reservation unless it has already been created
  before_save :create_reservation, unless: proc { |rental| rental.reservation_id.present? }

  # Note, rspec will mock this so we wont communicate with the api
  def create_reservation
    throw :abort unless (valid? and rental.valid?) # check if the current rental object is valid or not
    begin
      reservation = Inventory.create_reservation(item_type.name, rental.start_time, rental.end_time)
      raise 'Reservation UUID was not present in response.' unless reservation[:uuid].present?

      self.reservation_id = reservation[:uuid]
      self.item = Item.find_by(name: reservation[:item][:name])
    rescue => error
      errors.add :base, error.inspect
      throw :abort
    end
  end
end
