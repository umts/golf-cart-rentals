require 'rails_helper'

RSpec.describe Damage, type: :model do
  let(:damage) { create :damage }
  context 'validations' do
    it 'has a valid factory' do
      expect(damage).to be_valid
    end
  end
end
