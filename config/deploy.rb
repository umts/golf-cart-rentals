# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'golf-cart-rentals'
set :repo_url, 'git@github.com:umts/golf-cart-rentals.git'
set :deploy_to, '/var/www/golf-cart-rentals'
set :migration_role, :app

set :linked_files, %w{config/database.yml config/config.yml config/secrets.yml config/inventory_api_keys.yml}
SSHKit.config.umask = '002'
remote_user = Net::SSH::Config.for('umaps-web2.oit.umass.edu')[:user] || ENV['USER']
set :tmp_dir, "/tmp/#{remote_user}"
