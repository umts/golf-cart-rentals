require 'rails_helper'

describe ApplicationHelper do
  include Rails.application.routes.url_helpers
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

  describe '#link_to' do
    it 'returns nil if @current_user does not have access to an object' do
      expect(helper.link_to('Rentals', rentals_path)).to be_nil
    end

    it 'returns html if @current user does have access to a route' do
      current_user.groups << create(:admin_group)
      expect(helper.link_to('Rentals', rentals_path)).to include('href', 'rentals')
    end

    it 'returns html if @current user does have access to an object' do
      current_user.groups << create(:admin_group)
      rental = create(:rental)
      expect(helper.link_to('Rentals', rentals_path(rental))).to include('href', 'rentals', rental.id.to_s)
    end

    it 'returns html if @current user does have access to an object, with block options' do
      current_user.groups << create(:admin_group)
      rental = create(:rental)
      expect(helper.link_to(rental) {rental.id }).to include('href', 'rentals', rental.id.to_s)
    end
  end

  describe '#button_to' do
    it 'raises an error' do
      expect{helper.button_to(anything)}.to raise_error(RuntimeError)
    end
  end
end
