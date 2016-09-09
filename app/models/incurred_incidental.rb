# frozen_string_literal: true
class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  belongs_to :incidental_type

  has_one :financial_transaction, as: :transactable
  has_many :notes, as: :noteable

  has_many :incurred_incidentals_documents, dependent: :destroy
  has_many :documents, through: :incurred_incidentals_documents

  accepts_nested_attributes_for :notes

  validates_associated :rental, :incidental_type, :notes

  validates :times_modified, presence: true, numericality: true
  validates :rental, presence: true
  validates :incidental_type, uniqueness: { scope: :rental, message: 'should happen once per rental' },
                              presence: true

  after_create :create_financial_transaction

  def fee
    incidental_type.base + (times_modified * incidental_type.modifier_amount)
  end

  # private
  def create_financial_transaction
    FinancialTransaction.create rental: rental, amount: fee, transactable_type: self.class, transactable_id: id
  end
end
