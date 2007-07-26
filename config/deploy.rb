
set :application, "tcrbb"
set :repository, "/usr/local/hg/tcrbb"
set :use_sudo, false

role :web, "looneys.net"
role :app, "looneys.net"
role :db,  "looneys.net", :primary=>true

set :deploy_to, "/home/mml/tcrbb" # defaults to "/u/apps/#{application}"
set :scm, :mercurial               # defaults to :subversion


desc "start up the cluster"
task :spinner, :roles=>:app do
  run "cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::start"
end

desc "restart the cluster"
task :restart, :roles=>:app do
    run "cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::restart"
end
