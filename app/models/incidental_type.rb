class IncidentalType < ActiveRecord::Base
  has_many :incurred_incidentals, dependent: :destroy

  validates :name, :description, :base, :modifier_amount, :modifier_description, presence: true
  validates :name, uniqueness: true
  validates :base, :modifier_amount, numericality: { greater_than_or_equal_to: 0 }
end
