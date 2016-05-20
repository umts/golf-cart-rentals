require 'rails_helper'

describe ApplicationHelper do
  let!(:user) { create(:user) }

  before(:each) { current_user }

  describe '#rental_status_css_class and #rental_status_english' do
    after :each do
      Timecop.return
      Rental.last.destroy
    end

    it 'returns #danger if it is overdue' do
      rental = nil
      expect { rental = create :mock_rental, start_time: Time.current, end_time: Time.current + 1.day }.not_to raise_error
      rental.pickup
      Timecop.travel(Time.current + 1.day)
      expect(rental_status_css_class(rental)).to eq('danger')
      expect(rental_status_english('danger')).to eq('Overdue return')
    end

    it 'returns nil if it is canceled' do
      rental = nil
      expect { rental = create :mock_rental, start_time: Time.current, end_time: Time.current + 1.day }.not_to raise_error
      rental.cancel
      Timecop.travel(Time.current + 1.day)
      expect(rental_status_css_class(rental)).to be_nil
      expect(rental_status_english('')).to be_nil
    end

    it 'returns #info if checked out and on schedule' do
      rental = nil
      expect { rental = create :mock_rental, end_time: Time.current + 1.day }.not_to raise_error
      rental.pickup
      expect(rental_status_css_class(rental)).to eq('info')
      expect(rental_status_english('info')).to eq('Ongoing rental')
    end

    it 'returns #warning if not checked out and start time is in the past' do
      rental = nil
      expect { rental = create :mock_rental, start_time: Time.current, end_time: Time.current + 1.day }.not_to raise_error
      expect(rental_status_css_class(rental)).to eq('warning')
      expect(rental_status_english('warning')).to eq('Overdue for pickup')
    end

    it 'returns #success if reserved and start time is today' do
      rental = nil
      expect { rental = create :mock_rental, start_time: Time.current + 1.hour, end_time: Time.current + 1.day }.not_to raise_error
      expect(rental_status_css_class(rental)).to eq('success')
      expect(rental_status_english('success')).to eq('Reserved pickup imminent')
    end

    it 'returns #active if reserved and start time before current and after today' do
      rental = nil
      expect { rental = create :mock_rental, start_time: Time.current + 2.days, end_time: Time.current + 4.days }.not_to raise_error
      expect(rental_status_css_class(rental)).to eq('active')
      expect(rental_status_english('active')).to eq('Reserved future')
    end
  end
end
