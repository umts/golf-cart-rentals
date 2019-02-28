# frozen_string_literal: true

class IncurredIncidental < ActiveRecord::Base
  has_paper_trail

  belongs_to :rental
  belongs_to :item
  belongs_to :incidental_type

  has_one :damage, dependent: :destroy # zero or one damages, depending on incidental_type
  has_one :financial_transaction, as: :transactable
  has_many :notes, as: :noteable
  has_many :documents, as: :documentable, dependent: :destroy

  accepts_nested_attributes_for :notes, reject_if: proc { |attributes| attributes.all? { |_, v| v.blank? } }
  accepts_nested_attributes_for :financial_transaction
  accepts_nested_attributes_for :documents, reject_if: proc { |attributes|
    attributes[:description].blank?
  }

  validates :rental, :notes, :item, presence: true
  validates :incidental_type, presence: true,
                              uniqueness: { scope: :rental,
                                            message: 'should happen once per rental' }

  validates_associated :rental, :incidental_type, :notes, :documents
end
