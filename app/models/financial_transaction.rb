# frozen_string_literal: true
class FinancialTransaction < ActiveRecord::Base
  after_initialize :init
  belongs_to :rental
  belongs_to :transactable, polymorphic: true

  validates :adjustment, :rental_id, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def init
    self.adjustment ||= 0 # default
  end
end
