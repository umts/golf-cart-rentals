# frozen_string_literal: true
class Payment < ApplicationRecord
  has_one :financial_transaction, as: :transactable
  enum payment_type: [:credit, :debit, :recharge, :cash]
  validates :payment_type, :contact_name, :contact_email, :contact_phone, presence: true
  validates :contact_phone, length: { is: 10 }
end
