class RentalsItem < ActiveRecord::Base
  has_paper_trail
  # use inverse of so we can create this with rental blank at first
  belongs_to :rental, inverse_of: :rentals_items
  belongs_to :item
  belongs_to :item_type
  validates :rental, :item, :item_type, presence: true
  validates :reservation_id, uniqueness: true, allow_nil: true

  alias_attribute :reservation, :reservation_id
end
