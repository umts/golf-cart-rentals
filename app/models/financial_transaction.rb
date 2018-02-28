# frozen_string_literal: true
class FinancialTransaction < ActiveRecord::Base
  after_initialize :default
  after_save :send_updated_invoice

  belongs_to :rental
  belongs_to :transactable, polymorphic: true

  validates :rental_id, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  
  scope :payments, -> { where(transactable_type: Payment.name) }

  def default
    self.amount ||= 0
  end

  def send_updated_invoice
    InvoiceMailer.send_invoice(rental).deliver_later
  end
end
