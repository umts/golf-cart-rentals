require 'rails_helper'

RSpec.describe FinancialTransaction, type: :model do
  describe 'creates a financial transaction per transactable model' do
    after :each do
      @financial_transaction
    end

    it 'builds an IncidentalType' do
      expect(build(:incidental_type)).to be_valid
    end
    it 'fails to build when it is missing data' do
      expect(build(:incidental_type, name: nil)).not_to be_valid
      expect(build(:incidental_type, description: nil)).not_to be_valid
      expect(build(:incidental_type, base: nil)).not_to be_valid
      expect(build(:incidental_type, modifier_amount: nil)).not_to be_valid
      expect(build(:incidental_type, modifier_description: nil)).not_to be_valid
    end
    it 'wont create two types with the same name' do
      same = create(:incidental_type)
      expect(build(:incidental_type, name: same.name)).not_to be_valid
    end
  end
end
