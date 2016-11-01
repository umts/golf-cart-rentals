# frozen_string_literal: true
source 'https://rubygems.org'
ruby '2.3.1'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '5.0.0.1'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platform: :ruby
gem 'rails_serve_static_assets'
# Interaction with jquery and controller without refreshing page
gem 'gon'
gem 'fullcalendar-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'backstretch-rails'

# Use signature pad
gem 'signature-pad-rails', '~> 0.5'

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
# wicked pdf
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'js-routes'
# deployment
# gem 'savon'
# gem 'capistrano', '~> 3.3.0'
# gem 'capistrano-rails', '~> 1.1'
# gem 'capistrano-rvm'
# gem 'capistrano-passenger'

group :production do
  gem 'pg' # got to use postgres for heroku
  gem 'thin'
  gem 'rails_12factor'
end

# permanent records
gem 'permanent_records'

gem 'aggressive_inventory', git: 'https://github.com/tomecho/aggressive_inventory.git'

group :development, :test do
  # Use mariadb as the database for Active Record in dev and test environments
  gem 'mysql2'
  gem 'pry-byebug'
  gem 'rails-controller-testing'
  gem 'rspec-rails', '3.5.0.beta2'
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
  # gem 'capybara', git: 'https://github.com/jnicklas/capybara.git'
  gem 'rake'
  gem 'timecop'
  gem 'codeclimate-test-reporter', require: nil
  gem 'simplecov'
end
