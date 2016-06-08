require 'rails_helper'

RSpec.describe IncurredIncidental, type: :model do
  context 'properly does validations' do
    it 'builds a IncurredIncidental given proper parameters' do
      expect(build(:incurred_incidental)).to be_valid
    end

    it 'doesnt build when given improper params' do
      expect(build(:incurred_incidental, times_modified: nil)).not_to be_valid
    end
  end

  context 'properly does fee calculation' do
    it 'calculates a fee properly' do
      incident = create(:incurred_incidental)
      type = incident.incidental_type
      expect(incident.fee).to eq(type.base + (incident.times_modified * type.modifier_amount))
    end
  end
end
