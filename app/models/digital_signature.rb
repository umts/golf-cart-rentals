class DigitalSignature < ActiveRecord::Base
  belongs_to :rental
  validates :image, :intent, presence: true
end
