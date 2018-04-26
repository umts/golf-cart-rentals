require 'rails_helper'

describe 'creating a new rental' do
  before :each do
    @tomorrow = Date.tomorrow
    @day_after = @tomorrow + 1.day
  end

  describe 'form autopopulation' do
    before :each do
      visit '/rentals/new'
      @today = Date.today.strftime('%Y-%m-%d')
    end

    it 'populates the fields with the correct data' do
      expect(find_by_id('rental_start_time').value).to eql @today
    end
  end
end
