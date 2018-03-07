# frozen_string_literal: true
class Payment < ApplicationRecord
  enum payment_type: [:recharge]
  has_one :financial_transaction, as: :transactable

  before_validation do
    self.contact_phone = contact_phone.gsub(/\W/, '') if attribute_present? 'contact_phone'
  end

  validates :payment_type, :contact_name, :contact_phone, :contact_email, presence: true
  validates :contact_phone, format: { with: /\A\d{8,}\z/,
                                      message: 'Phone number should not contain any letters and be at least 8 digits long' }
  validates :contact_email, format: { with: /\A[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\z/,
                                      message: 'Email improperly formatted' }
end
