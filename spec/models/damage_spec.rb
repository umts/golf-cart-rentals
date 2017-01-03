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
    # also depends on hold, but wont test because it reaches out to api
    
    it 'on damage destroy, it destroys the incurred incidental with it' do 
      damage # need to create before we can test destroying it
      expect do
        damage.destroy
      end.to change(IncurredIncidental, :count).by(-1) and change(Damage,:count).by(-1)
    end

    it 'on incurred incidental destroy, it destroys the damage with it' do
      damage # need to create before we can test destroying it
      expect do
        damage.incurred_incidental.destroy
      end.to change(IncurredIncidental, :count).by(-1) and change(Damage,:count).by(-1)
    end
  end
end
