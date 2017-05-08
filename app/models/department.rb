# frozen_string_literal: true
class Department < ActiveRecord::Base
  has_many :users
  has_many :created_rentals, through: :users
  has_many :rented_rentals, through: :users

  validates :name, presence: true
  validates :name, uniqueness: true
end
