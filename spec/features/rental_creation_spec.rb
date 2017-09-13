require 'rails_helper'

feature 'Creating a new Rental' do

  # need to set selenium driver at some point to test javascript related features
  # before(:all) do
  #   Capybara.current_driver = :selenium
  # end
  #
  # after(:all) do
  #   Capybara.use_default_driver
  # end

  before(:each) do
    @a_user = create(:admin_user)
    # this line is broken, need to find some way to set @current_user in rentals_controller
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@a_user)

    @item_type = create(:item_type)

    @tomorrow = Date.today + 1
    @day_after = @tomorrow + 1
  end

  scenario 'Form fields are autopopulated' do
    visit new_rental_url
    # some fields are autopopulated but it's difficult to test their values
    # might be worth to investigate in the future
    within 'form.new_rental' do
      @today = Date.today.strftime('%Y-%m-%d')
      expect(find_by_id('rental_item_type_id').value).to eql @item_type.id.to_s
      expect(find_by_id('rental_start_time').value).to eql @today
      expect(find_by_id('rental_end_time').value).to eql @today
      expect(find_by_id('rental_date_range').value).to eql '1'
    end
  end

  # none of the following tests work because the selenium-webdriver doesn't seem
  # to be able to open the rental creation form. investigate in future
  @javascript
  scenario 'Creating a Rental with valid parameters' do
    visit new_rental_url
    binding.pry
    expect(Rental.count).to be 0

    within 'form.new_rental' do
      check('TOC')
    end
    confirmation_window = window_opened_by { find_by_id('rentalSubmit').click }
    within_window(confirmation_window) { click_button('OK') }

    expect(Rental.count).to be 1
  end

  @javascript
  scenario 'Creating an invalid Rental with non-existent User' do
    visit new_rental_url
    expect(Rental.count).to be 0

    within('form.new_rental') do
      fill_in('rental_renter_id', with: 'I do not exist')
      check('TOC')
    end
    confirmation_window = window_opened_by { find_by_id('rentalSubmit').click }
    within_window(confirmation_window) { click_button('OK') }

    expect(Rental.count).to be 0
  end

  scenario 'Creating an invalid Rental with past dates' do
    visit '/rentals/new'
    within('form.new_rental') do
      yesterday = Date.today - 1
      two_days_ago = Date.today - 2

      fill_in('rental_start_time', with: yesterday.strftime('%Y-%m-%d'))
      fill_in('rental_end_time', with: two_days_ago.strftime('%Y-%m-%d'))
      check('TOC')
    end

    click_button('rentalSubmit')
  end

  scenario 'Creating an invalid Rental with end < start dates' do
    visit '/rentals/new'
    within('form.new_rental') do
      fill_in('rental_start_time', with: day_after.strftime('%Y-%m-%d'))
      fill_in('rental_end_time', with: tomorrow.strftime('%Y-%m-%d'))
      check('TOC')
    end

    click_button('rentalSubmit')
  end
end
