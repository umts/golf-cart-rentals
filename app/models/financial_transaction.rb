# frozen_string_literal: true
class FinancialTransaction < ActiveRecord::Base
  after_initialize :init
  belongs_to :rental
  belongs_to :transactable, polymorphic: true

  after_save :send_updated_invoice

  validates :adjustment, :rental_id, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  def init
    self.adjustment ||= 0 # default
  end

  def send_updated_invoice
    InvoiceMailer.send_invoice(rental).deliver_later
  end
end
