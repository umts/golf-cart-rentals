# frozen_string_literal: true
class FinancialTransaction < ActiveRecord::Base
  after_initialize :default
  after_save :send_updated_invoice

  belongs_to :rental
  belongs_to :transactable, polymorphic: true

  validates :adjustment, :rental_id, :initial_amount, presence: true
  validates :initial_amount, numericality: { greater_than: 0 }

  alias_attribute :base_amount, :initial_amount

  def default
    self.adjustment ||= 0
    self.initial_amount ||= 0
  end

  def send_updated_invoice
    InvoiceMailer.send_invoice(rental).deliver_later
  end

  def zero_balance(note = 'Zeroed Balance')
    update adjustment: -initial_amount, note_field: note
  end

  def value
    initial_amount + adjustment
  end

  alias balance value
end
