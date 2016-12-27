class Damage < ApplicationRecord
  # validate presence of initial data
  validates :location, :description, :occured_on, :estimated_cost, presence: true
  belongs_to :incurred_incidental, dependent: :destroy
  belongs_to :hold, dependent: :destroy
end
