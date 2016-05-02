require 'codeclimate-test-reporter'
require 'factory_girl_rails'
require 'simplecov'

SimpleCov.start

CodeClimate::TestReporter.start

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
