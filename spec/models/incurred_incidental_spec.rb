# frozen_string_literal: true
require 'rails_helper'

RSpec.describe IncurredIncidental, type: :model do
  context 'properly does validations' do
    it 'builds a IncurredIncidental given proper parameters' do
      expect(build(:incurred_incidental)).to be_valid
    end

    it 'doesnt build when incidental_type_id is nil' do
      expect(build(:incurred_incidental, incidental_type_id: nil)).not_to be_valid
    end

    it 'doesnt build when rental_id is nil' do
      expect(build(:incurred_incidental, rental_id: nil)).not_to be_valid
    end

    it 'doesnt build when amount is < 0' do
      expect(build(:incurred_incidental, amount: -5)).not_to be_valid
    end

    it 'doesnt build when amount is nil' do
      expect(build(:incurred_incidental, amount: nil)).not_to be_valid
    end

    it 'doesnt build when amount is not a number' do
      expect(build(:incurred_incidental, amount: 'NaN')).not_to be_valid
    end

    it 'doesnt build without a note' do
      incidental = build(:incurred_incidental)
      incidental.notes.delete_all
      expect(incidental).not_to be_valid
    end
  end
end
