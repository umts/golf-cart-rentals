class DigitalSignature < ActiveRecord::Base
  belongs_to :rental
  validates :image, :intent, :author, presence: true
  enum author: { csr: 0, customer: 1 }
  enum intent: { check_out: 0, check_in: 1 } # later add intent damages
end
