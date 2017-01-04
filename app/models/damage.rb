# frozen_string_literal: true
class Damage < ApplicationRecord
  # validate presence of initial data
  validates :location, :description, :occurred_on, :estimated_cost, :incurred_incidental_id, presence: true
  validates :incurred_incidental_id, uniqueness: true
  belongs_to :incurred_incidental, dependent: :destroy
  belongs_to :hold, dependent: :destroy
  has_one :item, through: :incurred_incidental
end
