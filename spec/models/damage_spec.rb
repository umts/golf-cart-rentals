require 'rails_helper'
RSpec.describe Damage, type: :model do
  let(:damage) { create :damage }
  context 'validations' do
    it 'has a valid factory' do
      expect(damage).to be_valid
    end

    it 'validates uniquness of incurred_incidental_id' do
      expect(create :damage, incurred_incidental_id: 4).to be_valid
      expect(build :damage, incurred_incidental_id: 4).not_to be_valid
    end
  end

  context 'dependent destruction' do
    it 'destroys the hold with it (if there is one)' do
      damage.hold = create :hold # item doesnt really matter

    end

    it 'destroys the incurred incidental with it' do 
    
    end
  end
end
