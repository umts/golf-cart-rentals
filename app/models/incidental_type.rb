class IncidentalType < ActiveRecord::Base
  has_many :incurred_incidental
  validates :name, :description, :base, :modifier_amount, :modifier_description, presence: true
  validates :name, uniqueness: true
  validates :base, :modifier_amount, numericality: { greater_than_or_equal_to: 0 }
end
