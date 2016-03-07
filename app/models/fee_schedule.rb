class FeeSchedule < ActiveRecord::Base
  belongs_to :item_type
  validates :base_amount, :amount_per_day, presence: true
end
