class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  belongs_to :incidental_type
  validates :times_modified, :notes, presence: true
  validates_associated :incidental_type

  def fee
    incidental_type.base + (times_modified * incidental_type.modifier_amount)
  end
end
