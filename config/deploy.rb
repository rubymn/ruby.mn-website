
set :application, "tcrbb"
set :repository, "/usr/local/hg/tcrbb"

role :web, "looneys.net"
role :app, "looneys.net"
role :db,  "looneys.net", :primary=>true

set :deploy_to, "/home/mml/tcrbb" # defaults to "/u/apps/#{application}"
set :scm, :mercurial               # defaults to :subversion

desc <<DESC
An imaginary backup task. (Execute the 'show_tasks' task to display all
available tasks.)
DESC
task :backup, :roles => :db, :only => { :primary => true } do
  # the on_rollback handler is only executed if this task is executed within
  # a transaction (see below), AND it or a subsequent task fails.
  on_rollback { delete "/tmp/dump.sql" }

  run "mysqldump -u root > /tmp/tcrbb.sql"
end

task :spinner, :roles=>:app do
  run "cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::start"
end

task :before_update do
  transaction do
    run "cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::stop"
  end
end

task :restart, :roles=>:app do
  transaction do
    run "cd #{deploy_to}/#{current_dir} && mongrel_rails cluster::start"
  end
end
