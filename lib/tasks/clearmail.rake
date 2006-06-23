task :clearmail  do |t|
  require 'rubygems'
  require_gem 'activerecord'

  myconfig=YAML.load(File.open("#{RAILS_ROOT}/config/database.yml"))
  ActiveRecord::Base.establish_connection(myconfig[RAILS_ENV])
  ListMail.destroy_all
  puts "Cleared mail table"
end
