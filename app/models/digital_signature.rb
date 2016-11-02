# frozen_string_literal: true
class DigitalSignature < ActiveRecord::Base
  belongs_to :rental
  validates :image, :intent, :author, presence: true
  enum author: { csr: 0, customer: 1 }
  enum intent: { pickup: 0, drop_off: 1 } # later add intent damages
end
