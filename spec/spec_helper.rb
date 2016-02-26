require 'codeclimate-test-reporter'
require 'factory_girl_rails'

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
end
