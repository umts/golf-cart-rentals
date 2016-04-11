class DepartmentsUser < ActiveRecord::Base
  belongs_to :department
  belongs_to :user

  validates :user_id, uniqueness: true
end
