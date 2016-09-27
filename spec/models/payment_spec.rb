require 'rails_helper'

RSpec.describe Payment, type: :model do
  context 'validations' do
    it 'requires payment_type' do
      expect(build :payment, payment_type: nil).not_to be_valid
    end

    it 'requires contact_name' do
      expect(build :payment, contact_name: nil).not_to be_valid
    end

    it 'requires contact_email' do
      expect(build :payment, contact_email: nil).not_to be_valid
    end

    it 'requires contact_phone' do
      expect(build :payment, contact_phone: nil).not_to be_valid
    end
  end
end
