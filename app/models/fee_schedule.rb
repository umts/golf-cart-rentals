# frozen_string_literal: true
class FeeSchedule < ActiveRecord::Base
  belongs_to :item_type
  has_one :financial_transaction, as: :transactable

  validates :base_amount, :amount_per_day, presence: true
end
