require 'rails_helper'

RSpec.describe DigitalSignature, type: :model do
  let(:ds) { create :digital_signature }

  context 'validations' do
    it 'has a valid factory' do
      expect(ds).to be_valid
    end
    it 'is not valid with an intent outside of the enum' do
      expect(build :digital_signature, intent: 'not valid')
    end
  end
end
