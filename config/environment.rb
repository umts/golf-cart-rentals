# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

APP_CONFIG = YAML::load(File.open("#{Rails.root}/config/config.yml"))

ActionMailer::Base.default from: ( ENV['mail_from'] || APP_CONFIG[Rails.env]['mail_from'] )
