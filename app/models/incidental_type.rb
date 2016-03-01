class IncidentalType < ActiveRecord::Base
  has_many :incurred_incidental
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :base
  validates :base, numericality: {greater_than_or_equal_to: 0}
  validates_presence_of :modifier_amount
  validates :modifier_amount, numericality: {greater_than_or_equal_to: 0}
  validates_presence_of :modifier_description

end
