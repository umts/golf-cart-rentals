# frozen_string_literal: true
class Damage < ApplicationRecord
  has_one :item, through: :incurred_incidental

  belongs_to :incurred_incidental, dependent: :destroy
  belongs_to :hold, dependent: :destroy

  validates :location, :description, :occurred_on, :estimated_cost, :incurred_incidental_id, presence: true
  validates :incurred_incidental_id, uniqueness: true
  validates :estimated_cost, numericality: { greater_than_or_equal_to: 0 }
end
