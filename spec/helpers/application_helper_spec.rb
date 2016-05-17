require 'rails_helper'

describe ApplicationHelper do
  let!(:user) { create(:user) }

  before(:each) { current_user }

  describe '#rental_status_css_class and #rental_status_english' do
    before do
      @item_type = create :item_type, name: 'TEST_ITEM_TYPE'
    end

    after :each do
      Rental.last.destroy 
      Timecop.return
    end
    
    it 'returns #danger if it is overdue' do
      rental = nil
      expect { rental = create :valid_rental, item_type: @item_type, start_time: Time.current, end_time: Time.current + 1.day }.not_to raise_error
      rental.pickup
      Timecop.travel(Time.current + 1.day)
      expect(rental_status_css_class(rental)).to eq('danger')
      expect(rental_status_english('danger')).to eq('Overdue return')
    end

    it 'returns #info if checked out and on schedule' do
      rental = nil
      expect { rental = create :valid_rental, item_type: @item_type, start_time: Time.current, end_time: Time.current + 1.day }.not_to raise_error
      rental.pickup
      expect(rental_status_css_class(rental)).to eq('info')
      expect(rental_status_english('info')).to eq('Ongoing rental')
    end
    
    it 'returns #warning if not checked out and start time is in the past' do
      rental = nil
      expect { rental = create :valid_rental, item_type: @item_type, start_time: Time.current, end_time: Time.current + 1.day }.not_to raise_error
      expect(rental_status_css_class(rental)).to eq('warning')
      expect(rental_status_english('warning')).to eq('Overdue for pickup')
    end
    
    it 'returns #success if reserved and start time is today' do
      rental = nil
      expect { rental = create :valid_rental, item_type: @item_type, start_time: Time.current + 1.hour, end_time: Time.current + 1.day }.not_to raise_error
      expect(rental_status_css_class(rental)).to eq('success')
      expect(rental_status_english('success')).to eq('Reserved pickup imminent')
    end
    
    it 'returns #active if reserved and start time before current and after today' do
      rental = nil
      expect { rental = create :valid_rental, item_type: @item_type, start_time: Time.current + 2.day, end_time: Time.current + 4.day }.not_to raise_error
      expect(rental_status_css_class(rental)).to eq('active')
      expect(rental_status_english('active')).to eq('Reserved future')
    end
  end
end
