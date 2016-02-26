require 'rails_helper'

RSpec.describe Rental, type: :model do
  describe 'rental_status' do
    before(:each) do
      @rental = Rental.create(user_id: 0, department_id: 0, reservation_id: 0, fee_schedule_id: 0)
    end

    it 'is reserved upon creation' do
      expect(@rental).to be_reserved
    end

    it 'is canceled after cancel' do
      @rental.cancel!
      expect(@rental).to be_canceled
    end

    it 'is checked_out after pickup' do
      @rental.pickup!
      expect(@rental.checked_out_at).not_to be_nil
      expect(@rental).to be_checked_out
    end

    it 'is checked_in after return' do
      @rental.pickup
      @rental.return!
      expect(@rental.checked_in_at).not_to be_nil
      expect(@rental).to be_checked_in
    end

    it 'is inspected after inspect' do
      @rental.pickup
      @rental.return
      @rental.inspect!
      expect(@rental).to be_inspected
    end
    # or should they just go back to the pool after inspection? maybe not if damaged
    # should there be a "damaged" state?
    it 'is available after process' do
      @rental.pickup
      @rental.return
      @rental.inspect
      @rental.process!
      expect(@rental).to be_available
    end
  end
end
