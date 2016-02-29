require 'rails_helper'

RSpec.describe Rental do
  describe 'rental_status' do
    let(:rental) { create :rental }

    it 'is reserved upon creation' do
      expect(rental).to be_reserved
    end

    it 'is canceled after cancel' do
      rental.cancel!
      expect(rental).to be_canceled
    end

    it 'is checked_out after pickup' do
      rental.pickup!
      expect(rental.checked_out_at).not_to be_nil
      expect(rental).to be_checked_out
    end

    it 'is checked_in after return' do
      rental.pickup
      rental.return!
      expect(rental.checked_in_at).not_to be_nil
      expect(rental).to be_checked_in
    end

    it 'is inspected after inspect' do
      rental.pickup
      rental.return
      rental.inspect!
      expect(rental).to be_inspected
    end

    it 'is available after process' do
      rental.pickup
      rental.return
      rental.inspect
      rental.process!
      expect(rental).to be_available
    end
  end
end
