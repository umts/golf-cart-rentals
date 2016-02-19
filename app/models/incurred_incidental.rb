class IncurredIncidental < ActiveRecord::Base
  #belongs_to :rental
  has_one :incidental_type
end
