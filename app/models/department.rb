class Department < ActiveRecord::Base
  has_many :users

  validates :name, presence: true
  validates :name, uniqueness: true
end
