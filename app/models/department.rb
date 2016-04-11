class Department < ActiveRecord::Base
  has_many :departments_users, dependent: :destroy
  has_many :users, through: :departments_users

  validates :name, presence: true
  validates :name, uniqueness: true
end
