class FinancialTransaction < ActiveRecord::Base
  belongs_to :financial_type
end
