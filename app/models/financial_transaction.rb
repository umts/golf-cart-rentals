class FinancialTransaction < ActiveRecord::Base
  belongs_to :rental
  belongs_to :transactable, polymorphic: true

  validates :rental_id, presence: true

  def self.get_rental_summation(rental_id)
    FinancialTransaction.where(rental_id: rental_id).sum(:amount)
  end
end
