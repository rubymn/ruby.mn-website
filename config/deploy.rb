
set :application, "ruby-mn"
set :use_sudo, false

role :web, "looneys.net"
role :app, "looneys.net"
role :db,  "looneys.net", :primary=>true

set :repository, "http://bitbucket.org/mml/ruby-mn-site"
set :deploy_to, "/var/apps/#{application}"
set :scm, :mercurial               # defaults to :subversion



namespace :deploy do
  desc "restart the cluster"
  task :restart, :roles=>:app do
    run "sudo /etc/init.d/apache2 restart"
  end
  task :restart, :roles=>:app do
    run "sudo /etc/init.d/apache2 restart"
  end

end
