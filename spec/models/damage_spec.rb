# frozen_string_literal: true
require 'rails_helper'
RSpec.describe Damage, type: :model do
  context 'validations' do
    it 'validates uniquness of incurred_incidental_id' do
      incurred_incidental = create :incurred_incidental
      expect(create(:damage, incurred_incidental: incurred_incidental)).to be_valid
      expect(build(:damage, incurred_incidental: incurred_incidental)).not_to be_valid
    end
  end

  context 'dependent destruction' do
    # also depends on hold, but wont test because it reaches out to api

    it 'on damage destroy, it destroys the incurred incidental with it' do
      damage = create :damage
      expect do
        damage.destroy
      end.to(change(IncurredIncidental, :count).by(-1)) && change(Damage, :count).by(-1)
    end

    it 'on incurred incidental destroy, it destroys the damage with it' do
      damage = create :damage
      expect do
        damage.incurred_incidental.destroy
      end.to(change(IncurredIncidental, :count).by(-1)) && change(Damage, :count).by(-1)
    end
  end
end
