class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  belongs_to :incidental_type

  has_many :incurred_incidentals_documents, dependent: :destroy
  has_many :documents, through: :incurred_incidentals_documents
  has_many :notes, as: :noteable

  accepts_nested_attributes_for :notes

  validates :incidental_type_id, :times_modified, presence: true
  validates :times_modified, numericality: true
  validates_associated :incidental_type, :notes

  def fee
    is_active? ? incidental_type.base + (times_modified * incidental_type.modifier_amount) : 0
  end

end
