# frozen_string_literal: true
class FinancialTransaction < ActiveRecord::Base
  after_initialize :default
  after_save :send_updated_invoice

  belongs_to :rental
  belongs_to :transactable, polymorphic: true

  validates :rental_id, :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  alias_attribute :base_amount, :amount
  alias_attribute :initial_amount, :amount

  def default
    self.adjustment ||= 0
    self.initial_amount ||= 0
  end

  def send_updated_invoice
    InvoiceMailer.send_invoice(rental).deliver_later
  end

  def value
    initial_amount
  end

  alias balance value
end
