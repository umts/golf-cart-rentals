class DigitalSignature < ActiveRecord::Base
  validates :image, :intent, presence: true
end
