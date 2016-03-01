class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  belongs_to :incidental_type
  validates_presence_of :times_modified

  validates_presence_of :notes
  validates_associated :incidental_type

  def get_fee
    incidental_type.base + (times_modified * incidental_type.modifier_amount)
  end
end
