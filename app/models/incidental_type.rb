# frozen_string_literal: true
class IncidentalType < ActiveRecord::Base
  has_many :incurred_incidentals, dependent: :destroy

  validates :name, :description, :base, :modifier_description, presence: true
  validates :name, uniqueness: true
  validates :base, numericality: { greater_than_or_equal_to: 0 }

  def basic_info
    "#{name} - $#{base}"
  end
end
