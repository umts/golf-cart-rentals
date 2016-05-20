class DigitalSignature < ActiveRecord::Base
  belongs_to :rental
  validates :image, :intent, :author, presence: true
  authors = { csr: 0, customer: 1 }
  enum author: authors
end
