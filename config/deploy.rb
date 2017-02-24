# config valid only for current version of Capistrano
lock '3.3.5'

set :application, 'probable-engine'
set :repo_url, 'git@github.com:umts/probable-engine.git'
set :deploy_to, '/var/www/probable-engine'
set :rvm_type, :system
set :linked_files, %w{config/database.yml config/config.yml config/secrets.yml}
SSHKit.config.umask = '002'

after :deploy, :finished do
  on roles(:web) do
    execute :rm, "-r /tmp/probable-engine/"
  end
end
