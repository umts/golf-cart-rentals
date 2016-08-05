# frozen_string_literal: true
class FinancialTransaction < ActiveRecord::Base
  belongs_to :rental
  belongs_to :transactable, polymorphic: true

  validates :rental_id, presence: true
  validates :amount, presence: true
  validates :adjustment, presence: true
end
