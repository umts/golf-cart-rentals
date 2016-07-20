class Item < ActiveRecord::Base
  belongs_to :item_type
  validates :name, :item_type_id, presence: true
  validates :item_type_id, numericality: { greater_than_or_equal_to: 0 }

  delegate :name, :base_fee, :fee_per_day, :disclaimer, to: :item_type, prefix: true
end
