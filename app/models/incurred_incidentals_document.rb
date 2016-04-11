class IncurredIncidentalsDocument < ActiveRecord::Base
  belongs_to :document
  belongs_to :incurred_incidental
end
