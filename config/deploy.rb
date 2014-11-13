require 'rvm/capistrano' # Для работы rvm
require 'bundler/capistrano' # Для работы bundler.


set :application, "weafam"
set :user, "weafam"
set :rails_env, "production"
set :domain, "weafam@128.199.38.4" # Это необходимо для деплоя через ssh.
set :deploy_to, "/home/weafam/www/#{application}"
set :use_sudo, false


set :rvm_ruby_string, 'ruby-2.1.4@weafam' # Ruby интерпретатор + gemset.
set :rvm_bin_path, "/home/#{user}/.rvm/bin/" # rvm bin path - rvm-shell
set :rvm_type, :user # rvm, установленный у пользователя, от которого происходит деплой, а не системный rvm.

default_run_options[:pty] = true

set :scm, :git # Используем git.
set :repository, "git@bitbucket.org:Mr_Pilot/weafam.git"
set :branch, "master" # Ветка из которой будем тянуть код для деплоя.
# set :deploy_via, :remote_cache # Указание на то, что стоит хранить кеш репозитария локально и с каждым деплоем лишь подтягивать произведенные изменения. Очень актуально для больших и тяжелых репозитариев.

role :web, domain
role :app, domain
role :db,  domain, :primary => true



# Настройка БД
namespace :db do
  desc "Create database yaml in shared path"
  task :default do
    db_config = ERB.new <<-EOF
    base: &base
      adapter: postgresql
      username: postgres
      password: interweb
      encoding: utf8
      reconnect: false
      pool: 5
      timeout: 5000
      host: 127.0.0.1


    production:
      database: weafam
      <<: *base
    EOF

    run "mkdir -p #{shared_path}/config"
    put db_config.result, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end


  desc "Load current seed.rb"
  task :seed do
    run "cd #{current_path}; bundle exec rake db:seed RAILS_ENV=#{rails_env}"
  end
end



namespace :deploy do
  desc "Restarting passenger with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

before  "deploy:setup", :db
after   "deploy:update_code", "db:symlink"
