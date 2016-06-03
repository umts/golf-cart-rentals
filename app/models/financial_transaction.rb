class FinancialTransaction < ActiveRecord::Base
  belongs_to :rental
  belongs_to :transactable, polymorphic: true

  validates :rental_id, presence: true
end
