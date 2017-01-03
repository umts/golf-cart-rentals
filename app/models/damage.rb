class Damage < ApplicationRecord
  # validate presence of initial data
  validates :location, :description, :occurred_on, :estimated_cost, :incurred_incidental, presence: true
  validates :incurred_incidental, uniqueness: true
  belongs_to :incurred_incidental, dependent: :destroy
  belongs_to :hold, dependent: :destroy
end
