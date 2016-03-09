class FinancialTransaction < ActiveRecord::Base
  belongs_to :rental
  belongs_to :transactable, polymorphic: true
end
