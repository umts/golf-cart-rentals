# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'probable-engine'
set :repo_url, 'git@github.com:umts/probable-engine.git'
set :deploy_to, '/var/www/probable-engine'
set :rvm_type, :system
set :linked_files, %w{config/database.yml config/config.yml config/secrets.yml config/inventory_api_keys.yml}
SSHKit.config.umask = '002'
remote_user = Net::SSH::Config.for('umaps-web2.oit.umass.edu')[:user] || ENV['USER']
set :tmp_dir, "/tmp/#{remote_user}"

namespace :deploy do
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      execute :touch, release_path.join("tmp/restart.txt")
      within current_path do
        execute :bundle, :exec, "rake permissions:update RAILS_ENV=production"
      end
    end
  end
end
