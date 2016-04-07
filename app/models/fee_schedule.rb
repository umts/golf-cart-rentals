class FeeSchedule < ActiveRecord::Base
  belongs_to :item_type
  validates :base_amount, :amount_per_day, :item_type_id, presence: true
  validates :base_amount, :amount_per_day, :numericality => { :greater_than_or_equal_to => 0 }
end
