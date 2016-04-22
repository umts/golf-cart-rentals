class ItemType < ActiveRecord::Base
  validates :name, :disclaimer, :base_fee, :fee_per_day, presence: true
  validates :base_fee, :fee_per_day, numericality: { greater_than_or_equal_to: 0 }
end
