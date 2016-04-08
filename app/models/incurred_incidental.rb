# frozen_string_literal: true
class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  belongs_to :incidental_type
  has_one :financial_transaction, as: :transactable

  has_many :notes, as: :noteable
  has_many :incurred_incidentals_documents, dependent: :destroy
  has_many :documents, through: :incurred_incidentals_documents

  after_create :create_financial_transaction

  validates :times_modified, presence: true
  validates :incidental_type, uniqueness: { scope: :rental, message: 'should happen once per rental' }
  validates_associated :incidental_type

  def re_de_activate
    is_active? ? is_active = false : is_active = true
  end

  def fee
    is_active? ? incidental_type.base + (times_modified * incidental_type.modifier_amount) : 0
  end

  # private
  def create_financial_transaction
    FinancialTransaction.create rental: rental, amount: fee, transactable_type: self.class, transactable_id: id
  end
end
