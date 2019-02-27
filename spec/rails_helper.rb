# frozen_string_literal: true
# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# Prevent database truncation if the environment is production
abort 'The Rails environment is running in production mode!' if Rails.env.production?

require 'factory_bot_rails'
require 'spec_helper'
require 'rspec/rails'
require 'capybara/rspec'
require 'capybara/rails'
require 'rack_session_access/capybara'

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.fixture_path = "#{::Rails.root}/spec/fixtures"
  config.use_transactional_fixtures = true
  config.infer_spec_type_from_file_location!
  config.before :suite do
    Permission.update_permissions_table
  end
  config.before :each do
    # Loganote: using .and_return({uuid:...} is not lazily evaluated
    allow(Inventory).to receive(:create_reservation) {
                          { uuid: SecureRandom.uuid,
                            item: { name: create(:item).name } }
                        }
    allow(Inventory).to receive(:update_reservation_start_time) {
      { start_time: Time.current }
    }
    allow(Inventory).to receive(:update_reservation_end_time) {
      { end_time: Time.current + 1.day }
    }
    allow(Inventory).to receive(:delete_reservation) {
      { uuid: nil }
    }
  end
  config.before :each, type: :system do
    driven_by :selenium_chrome_headless
  end
end
# Helper method
def current_user(user = nil)
  @current_user = if user
                    user
                  else
                    create(:user)
                  end
  controller.instance_variable_set('@current_user', @current_user)
end

def super_user
  create(:user, groups: [create(:group, permissions: Permission.all)])
end

def login_as(user)
  page.set_rack_session user_id: user.id
end
