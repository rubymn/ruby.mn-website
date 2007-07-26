
set :application, "tcrbb"
set :repository, "/usr/local/hg/tcrbb"
set :use_sudo, false

role :web, "looneys.net"
role :app, "looneys.net"
role :db,  "looneys.net", :primary=>true

set :deploy_to, "/home/mml/tcrbb" # defaults to "/u/apps/#{application}"
set :scm, :mercurial               # defaults to :subversion

after :update_code, :link_indexes

namespace :deploy do
  desc "start up the cluster"
  task :spinner, :roles=>:app do
    run "cd #{current_path} && mongrel_rails cluster::start"
  end

  desc "restart the cluster"
  task :restart, :roles=>:app do
    run "cd #{current_path} && mongrel_rails cluster::restart"
  end

  task :create_index, :roles=>:app do
    transaction do
      run "mkdir -p #{shared_path}/sphinx_data/log"
      run "ln -s #{shared_path}/sphinx_data #{current_path}/config/sphinx_data"
      run "cd #{current_path} && rake sphinx:stop && rake sphinx:index && rake sphinx:start"
    end
  end

  task :link_indexes, :roles=>:app do
      run "ln -s #{shared_path}/sphinx_data #{current_path}/config/sphinx_data"
      run "cd #{current_path} && rake sphinx:stop && rake sphinx:start"
  end

end
