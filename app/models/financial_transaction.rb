class FinancialTransaction < ActiveRecord::Base
  belongs_to :transactable, polymorphic: true
end
