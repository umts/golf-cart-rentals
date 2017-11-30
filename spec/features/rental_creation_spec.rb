require 'rails_helper'

describe 'Creating a new rental', js: true do

  before(:each) do
    # In the current state of this, these tests are using development data, so
    # it's acting as if the @current_user delegation is based on development
    # logic. That is, it is using the first user available in the development
    # database.

    @tomorrow = Date.today + 1
    @day_after = @tomorrow + 1
  end

  describe 'static page tests for the sake of testing' do

  end

  describe 'form autopopulation' do
    before(:each) do
      visit '/rentals/new'
      @today = Date.today.strftime('%Y-%m-%d')
    end

    # removed data_type_id test due to the weirdness of the generated select
    # object using 'data-id' instead of 'id' so find_by_id does not work.

    it 'populates fields' do
      # Normally I would spread this to 3 tests, but due to the way integration
      # tests are ran (using the browser), it is a significant performance gain
      # to place all 3 of these in 1 test.

      expect(find_by_id('rental_start_time').value).to eql @today
      expect(find_by_id('rental_end_time').value).to eql @today
      expect(find_by_id('rental_date_range').value).to eql '1'
    end
  end

  describe 'rental creation' do
    describe 'invalid' do
      it 'redirects to creation page again' do
        visit '/rentals/new'

        within('form.new_rental') do
          fill_in('rental_start_time', with: @tomorrow.strftime('%Y-%m-%d'))
          fill_in('rental_end_time', with: Date.today.strftime('%Y-%m-%d'))

          # check('TOC')
          puts page.html

          #click_button 'rentalSubmit'
          page.save_screenshot('page1.png')
          find_button('rentalSubmit').trigger('click')
          page.save_screenshot('page2.png')
          window.confirm
          #page.find_by_id('rentalSubmit').click
          #page.driver.browser.switch_to.alert.accept
        end
        page.save_screenshot('page3.png')
        sleep 3
        page.save_screenshot('page4.png')
        #page.evaluate_script('window.confirm = function() { return true; }')
        #accept_alert  do
        #  click_button 'rentalSubmit'
        #end
        #page.driver.browser.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoSuchAlertError

        # slightly confusing, but this is the relative url when redirecting
        # back to itself on a failed creation, not the index
        expect(page.current_path).to eql '/rentals'
      end
    end

    describe 'valid' do
      it 'redirects to index page' do
        visit '/rentals/new'
        puts page.html

        within 'form.new_rental' do
          # check('TOC')
        end

        find_button('rentalSubmit').trigger('click')
        #accept_alert
        window.confirm
        sleep 3

        #page.evaluate_script('window.confirm = function() { return true; }')
        # accept_alert do
        #     find_by_id('rentalSubmit').click
        # end
        # page.driver.browser.switch_to.alert.accept rescue Selenium::WebDriver::Error::NoSuchAlertError

        # Because it is using development data but the logic itself runs off
        # test data, neither "/rentals/1" (test) or "rentals/#{Rental.count}"
        # (dev) will work. This could prob be worked around by manually
        # setting the database for integration test logic but this regex will
        # only ever match when the submission is successful anyway.
        expect(page.current_path).to match /\/rentals\/\d/
      end
    end
  end
end
