# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Payment, type: :model do
  it 'has a valid factory' do
    expect(build(:payment)).to be_valid
  end

  context 'validations' do
    it 'requires payment_type' do
      expect(build(:payment, payment_type: nil)).not_to be_valid
    end

    it 'requires contact_name' do
      expect(build(:payment, contact_name: nil)).not_to be_valid
    end

    it 'requires contact_email' do
      expect(build(:payment, contact_email: nil)).not_to be_valid
    end

    it 'requires contact_phone' do
      expect(build(:payment, contact_phone: nil)).not_to be_valid
    end

    it 'requires length contact_phone to be 8' do
      expect(build(:payment, contact_phone: '1' * 7)).not_to be_valid
    end

    it 'has an optional reference field' do
      expect(build(:payment, reference: nil)).to be_valid
    end
  end

  context 'payment_type enum' do
    it 'accepts each of the valid payment_types' do
      Payment.payment_types.keys.each do |pt|
        expect(build(:payment, payment_type: pt)).to be_valid
      end
    end

    it 'doesnt accept non valid payment types' do
      expect { build :payment, payment_type: 'alapaca hooves' }.to raise_error ArgumentError
    end
  end
end
