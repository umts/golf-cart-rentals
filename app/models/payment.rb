# frozen_string_literal: true
class Payment < ApplicationRecord
  enum payment_type: [:recharge]
  has_one :financial_transaction, as: :transactable
  validates :payment_type, :contact_name, :contact_phone, :contact_email, presence: true
  validates :contact_phone, format: { with: /\d{10}/,
                                      message: 'Phone number should be 10 digits' }
  validates :contact_email, format: { with: /[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}/,
                                      message: 'Email improperly formatted'}
end
