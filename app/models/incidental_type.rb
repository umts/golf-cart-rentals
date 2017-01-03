# frozen_string_literal: true
class IncidentalType < ActiveRecord::Base
  has_many :incurred_incidentals, dependent: :destroy

  validates :name, :description, :base, presence: true
  validates :damage_tracked, inclusion: { in: [true, false] }
  validates :name, uniqueness: true
  validates :base, numericality: { greater_than_or_equal_to: 0 }

  def basic_info
    "#{name} ($#{base})"
  end
end
