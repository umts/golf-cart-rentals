require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'httparty'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ProbableEngine
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # once you uncomment every line in the file
    # config/initializers/new_framework_defaults_5_2,
    # you can remove this line
    config.load_defaults 5.0

    config.generators do |g|
      g.assets         false
      g.helper         false
      g.test_framework :rspec,
        :view_specs    => false,
        :request_specs => false,
        :routing_specs => false
    end

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += Dir["#{config.root}/app/models/inventory/**"]
    config.time_zone = 'Eastern Time (US & Canada)'

    config.active_job.queue_adapter = :sidekiq

    HTTParty::Basement.default_options.update(verify: false) # do not verify certs
  end
end
