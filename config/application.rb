require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'httparty'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module GolfCartRentals
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

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

    ActiveSupport.halt_callback_chains_on_return_false = false
    HTTParty::Basement.default_options.update(verify: false) # do not verify certs
  end
end
