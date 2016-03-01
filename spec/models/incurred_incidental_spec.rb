require 'rails_helper'

RSpec.describe IncurredIncidental, type: :model do
  context 'will properly do validations' do
    it 'builds a IncurredIncidental given proper parameters' do

      expect(IncurredIncidental.new(times_modified: 1.0, notes: "this isnt real", incidental_type_id: IncidentalType.new(name: 'test', description: 'this isnt a real IncidentalType', base: 2.0, modifier_amount: 2.0, modifier_description: 'two times as much!').id)).to be_valid
    end

    it 'doesnt build when given inproper params' do
      expect(IncurredIncidental.new(notes: "this isnt real")).not_to be_valid
      expect(IncurredIncidental.new(times_modified: 1.0)).not_to be_valid
    end
  end

  context 'properly does fee calculation' do
    it 'calculates a fee properly' do
      incident = create(:incurred_incidental)
      type = incident.incidental_type
      expect(incident.get_fee).to eq(type.base + (incident.times_modified * type.modifier_amount))
    end
  end
end
