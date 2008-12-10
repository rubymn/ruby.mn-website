
set :application, "tcrbb"
set :repository, "/usr/local/hg/tcrbb"
set :use_sudo, false

role :web, "looneys.net"
role :app, "looneys.net"
role :db,  "looneys.net", :primary=>true

set :deploy_to, "http://bitbucket.org/mml/ruby-mn-site"
set :scm, :mercurial               # defaults to :subversion

before 'deploy:restart', 'deploy:create_index'


namespace :deploy do
  desc "start up the cluster"

  desc "restart the cluster"
  task :restart, :roles=>:app do
    run "sudo /etc/init.d/apache2 restart"
  end
  task :after_update_code do
    run "ln -s /var/www/localhost/htdocs/recaptcha #{current_path}/public/recaptcha"
  end
  task :restart, :roles=>:app do
    run "sudo /etc/init.d/apache2 restart"
  end



end
