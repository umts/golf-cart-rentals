# frozen_string_literal: true

class Damage < ApplicationRecord

  belongs_to :incurred_incidental, dependent: :destroy
  # cannot define a has_many through before the association is defined
  has_one :item, through: :incurred_incidental
  belongs_to :hold, dependent: :destroy, optional: true

  validates :location, :description, :occurred_on, :estimated_cost, :incurred_incidental_id, presence: true
  validates :incurred_incidental_id, uniqueness: true
  validates :estimated_cost, numericality: { greater_than_or_equal_to: 0 }
end
