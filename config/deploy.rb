
set :application, "tcrbb"
set :repository, "/usr/local/hg/tcrbb"
set :use_sudo, false

role :web, "looneys.net"
role :app, "looneys.net"
role :db,  "looneys.net", :primary=>true

set :deploy_to, "/var/apps/tcrbb" # defaults to "/u/apps/#{application}"
set :scm, :mercurial               # defaults to :subversion

before 'deploy:restart', 'deploy:create_index'


namespace :deploy do
  desc "start up the cluster"
  task :spinner, :roles=>:app do
    run "thin -s  2 -d  -p 400 -c #{current_path} start"
  end

  desc "restart the cluster"
  task :restart, :roles=>:app do
    run "thin -s  2 -d  -p 4000 -c #{current_path} stop"
    run "thin -s  2 -d  -p 4000 -c #{current_path} start"
  end

  task :create_index, :roles=>:app do
    transaction do
      run "cp #{current_path}/config/sphinx.conf.prod #{current_path}/config/sphinx.conf"
      run "mkdir -p #{shared_path}/sphinx_data/log"
      run "ln -s #{shared_path}/sphinx_data #{current_path}/config/sphinx_data"
      run "cd #{current_path} && rake sphinx:stop && rake sphinx:index && rake sphinx:start"
    end
  end


end
