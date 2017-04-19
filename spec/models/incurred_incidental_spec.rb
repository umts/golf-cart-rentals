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

    it 'doesnt build without a note' do
      incidental = build(:incurred_incidental)
      incidental.notes.delete_all
      expect(incidental).not_to be_valid
    end
  end

  context 'time travel' do
    it 'can add an ii to a rental' do
      rental = create :rental
      Timecop.travel(rental.start_date + 1.day) # after the start date
      expect do
        create :incurred_incidental, rental: rental
      end.to change(IncurredIncidental, :count).by 1
    end

    after do
      Timecop.return
    end
  end
end
