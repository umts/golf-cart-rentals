require 'rails_helper'

RSpec.describe IncidentalType, type: :model do
  context 'will properly do validations' do
    it 'builds an IncidentalType' do
      expect(IncidentalType.new(name: 'test', description: 'this isnt a real IncidentalType', base: 2.0, modifier_amount: 2.0, modifier_description: 'two times as much!')).to be_valid
    end
    it 'fails to build when it is missing data' do
      expect(IncidentalType.new(description: 'this isnt a real IncidentalType', base: 2.0, modifier_amount: 2.0, modifier_description: 'two times as much!')).not_to be_valid
      expect(IncidentalType.new(name: 'test', base: 2.0, modifier_amount: 2.0, modifier_description: 'two times as much!')).not_to be_valid
      expect(IncidentalType.new(name: 'test', description: 'this isnt a real IncidentalType', modifier_amount: 2.0, modifier_description: 'two times as much!')).not_to be_valid
      expect(IncidentalType.new(name: 'test', description: 'this isnt a real IncidentalType', base: 2.0, modifier_description: 'two times as much!')).not_to be_valid
      expect(IncidentalType.new(name: 'test', description: 'this isnt a real IncidentalType', base: 2.0, modifier_amount: 2.0)).not_to be_valid
    end
  end
end
