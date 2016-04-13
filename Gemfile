source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
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

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# for tracking created/updated user info on a per model basis
gem 'paper_trail', '~> 4.0.0.rc'

# for handling the state machine behind rental statuses
gem 'aasm'

# for simplified api calls
gem 'httparty', '~> 0.13.7'

# bootstrap!
gem 'twitter-bootstrap-rails'
gem 'bootstrap-sass', '~> 3.3.5'
gem 'momentjs-rails', '>= 2.8.1'
gem 'bootstrap3-datetimepicker-rails', '~> 4.14.30'
gem 'bootstrap-switch-rails'
gem 'will_paginate-bootstrap'

# pagination
gem 'will_paginate'

# searchable pages
gem 'ransack'

# date validations
gem 'date_validator'

# deployment
# gem 'savon'
# gem 'capistrano', '~> 3.3.0'
# gem 'capistrano-rails', '~> 1.1'
# gem 'capistrano-rvm'
# gem 'capistrano-passenger'

group :development, :test do
  gem 'pry-byebug'
  gem 'rspec-rails', '~> 3.0'
  gem 'rubocop', require: false
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'better_errors'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'vcr', '2.4.0'
  gem 'factory_girl_rails'
  gem 'capybara', '~> 2.5'
  gem 'rake'
  gem 'timecop'
  gem 'codeclimate-test-reporter', require: nil
  gem 'simplecov'
end
