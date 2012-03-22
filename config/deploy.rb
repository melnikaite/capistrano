set :application, "capistrano"
set :repository,  "git@github.com:melnikaite/capistrano.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, "172.16.16.177"                          # Your HTTP server, Apache/etc
role :app, "172.16.16.177"                          # This may be the same as your `Web` server
role :db,  "172.16.16.177", :primary => true # This is where Rails migrations will run
#role :db,  "your slave db-server here"

set :deploy_to, "/usr/share/nginx/www"
set :user, "capistrano"
set :scm_username, "melnikaite"
default_run_options[:pty] = true

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
