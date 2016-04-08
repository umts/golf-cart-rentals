class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  belongs_to :incidental_type
  validates :times_modified, :notes, presence: true
  validates_associated :incidental_type

  def re_de_activate
    is_active? ? is_active = false : is_active = true
  end

  def fee
    is_active? ? incidental_type.base + (times_modified * incidental_type.modifier_amount) : 0
  end

end
