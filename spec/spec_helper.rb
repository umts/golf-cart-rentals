# frozen_string_literal: true
require 'factory_girl_rails'
require 'simplecov'
require 'capybara/rspec'

SimpleCov.start

RSpec.configure do |config|
  config.raise_errors_for_deprecations!

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.include FactoryGirl::Syntax::Methods

  config.before :suite do
    Permission.update_permissions_table
  end

  config.before(:each) do
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
