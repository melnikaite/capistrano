set :application, "capistrano"
set :keep_releases, 3

# RVM integration
# http://beginrescueend.com/integration/capistrano/
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))
require "rvm/capistrano"
set :rvm_ruby_string, "1.9.3-p125"
set :rvm_type, :user

# Bundler integration (bundle install)
# http://gembundler.com/deploying.html
require "bundler/capistrano"
set :bundle_without, [:development, :test]

set :user, "capistrano"
set :password, "capistrano"
set :deploy_to, "/opt/nginx/html"
set :use_sudo, false

# Must be set for the password prompt from git to work
# http://help.github.com/deploy-with-capistrano/
default_run_options[:pty] = true
set :scm, :git
set :repository, "git@github.com:melnikaite/capistrano.git"
set :branch, "master"
set :deploy_via, :remote_cache

# Multiple Stages Without Multistage Extension
# https://github.com/capistrano/capistrano/wiki/2.x-Multiple-Stages-Without-Multistage-Extension
desc "Deploy using internal address"
task :current do
  set :rails_env, "current"
  server "172.16.16.177", :app, :web, :db, :primary => true
end

desc "Deploy using external address"
task :production do
  set :rails_env, "production"
  server "172.16.16.177", :app, :web, :db, :primary => true
end

# http://modrails.com/documentation/Users%20guide%20Nginx.html#capistrano
namespace :deploy do
  desc "Start server"
  task :start, :roles => :app do
    run "#{try_sudo} touch #{File.join(release_path,'tmp','restart.txt')}"
  end
  
  # not supported by Passenger server
  task :stop, :roles => :app do
  end
  
  desc "Restart server"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(release_path,'tmp','restart.txt')}"
  end
  
  desc "Symlink shared configs and folders on each release."
  task :symlink_shared, :roles => :app do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    #run "ln -nfs #{shared_path}/assets #{release_path}/public/assets"
  end
end

namespace :rvm do
  desc "Create correct RVM file"
  task :create_rvmrc do
    run "cd #{current_path} && source ~/.rvm/scripts/rvm && rvm use 1.9.3-p125@rails320 --rvmrc --create && rvm rvmrc trust #{current_path}"
  end
end

after 'deploy:update_code', 'deploy:symlink_shared'
after "deploy", "deploy:migrate", "rvm:create_rvmrc", "deploy:start", "deploy:cleanup"

