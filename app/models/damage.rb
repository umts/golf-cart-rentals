class Damage < ApplicationRecord
  validate
#:type, :location, :repaired_by, :description,
#:comments, :occurred_on, :repaired_on,
#:estimated_cost, :actual_cost, :item, :rental
  belongs_to :incurred_incidental, dependent: :destroy
  belongs_to :rental, through: :incurred_incidental
end
