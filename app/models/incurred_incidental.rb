# frozen_string_literal: true
class IncurredIncidental < ActiveRecord::Base
  belongs_to :rental
  belongs_to :incidental_type

  has_one :damage, dependent: :destroy # zero or one damages, depending on incidental_type

  has_one :financial_transaction, as: :transactable
  has_many :notes, as: :noteable

  has_many :incurred_incidentals_documents, dependent: :destroy
  has_many :documents, through: :incurred_incidentals_documents

  accepts_nested_attributes_for :notes, reject_if: proc { |attributes| attributes.all? { |_, v| v.blank? } }

  validates_associated :rental, :incidental_type, :notes

  validates :rental, :notes, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :incidental_type, uniqueness: { scope: :rental, message: 'should happen once per rental' }, presence: true

  after_create :create_financial_transaction

  # private
  def create_financial_transaction
    FinancialTransaction.create(rental: rental, amount: amount, transactable_type: self.class, transactable_id: id)
  end
end
