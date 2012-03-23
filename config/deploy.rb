set :application, "capistrano"
set :repository,  "git@github.com:melnikaite/capistrano.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :deploy_to, "/usr/share/nginx/www"
set :user, "capistrano"
set :password, "capistrano"
set :scm_username, "melnikaite"
default_run_options[:pty] = true
set :branch, fetch(:branch, "master")
set :env, fetch(:env, "current")
set :keep_releases, 3
after "deploy", "deploy:cleanup"

task :current do
  server "172.16.16.177", :app, :web, :db, :primary => true
end

task :production do
  server "172.16.16.177", :app, :web, :db, :primary => true
end

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
