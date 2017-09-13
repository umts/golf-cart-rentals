# frozen_string_literal: true
source 'https://rubygems.org'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.2'
# Use mariadb as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platform: :ruby

# Interaction with jquery and controller without refreshing page
gem 'fullcalendar-rails'
gem 'gon'

# Use jquery as the JavaScript library
gem 'backstretch-rails'
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.0.1'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# for tracking created/updated user info on a per model basis
gem 'paper_trail', '~> 4.2.0'

# for handling the state machine behind rental statuses
gem 'aasm'

# for simplified api calls
gem 'httparty', '~> 0.13.7'

# bootstrap!
gem 'bootstrap-sass', '~> 3.3.5'
gem 'bootstrap-switch-rails'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'twitter-bootstrap-rails'
# javascript libaries
gem 'date_validator'
gem 'js-routes'
gem 'momentjs-rails', '>= 2.8.1'
gem 'rails-jquery-tokeninput'
# sorts tables ui side, very useful when columns are not columns in the database
gem 'jquery-datatables-rails', '~> 3.4.0'
# Use signature pad
gem 'signature-pad-rails', '~> 0.5'

# pagination
gem 'will_paginate'
gem 'will_paginate-bootstrap'

# searchable pages
gem 'ransack'

# deployment
gem 'capistrano', '~> 3.3.0'
gem 'capistrano-passenger'
gem 'capistrano-rails', '~> 1.1'
gem 'capistrano-rvm'

gem 'unicode_utils', '~> 1.4'

# permanent records
gem 'permanent_records'

# exception notifier
gem 'exception_notification'
gem 'slack-notifier'

gem 'aggressive_inventory', git: 'https://github.com/tomecho/aggressive_inventory.git'

group :development, :test do
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '3.5.0.beta2'
  gem 'rubocop', require: false
  gem 'timecop'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'better_errors'
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'factory_girl_rails'
  gem 'vcr', '2.4.0'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rake'
  gem 'simplecov'
end
