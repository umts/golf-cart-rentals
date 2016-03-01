class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  has_one :incidental_type
  validates_presence_of :times_modified
  validates_presence_of :notes
  validates_associated :incidental_type
end
