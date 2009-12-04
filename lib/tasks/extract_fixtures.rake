require 'erb'
require 'yaml'
include ERB::Util
task :extract_fixtures => :environment do 
  sql = "select * from %s"
  include_tables=['list_mails', 'messages_messages']
  ActiveRecord::Base.establish_connection
  include_tables.each do |tn|
    i = 0
    File.open("#{RAILS_ROOT}/test/fixtures/#{tn}.yml", 'w') do | file|
      data = ActiveRecord::Base.connection.select_all(sql % tn)
      file.write data.inject({}) {|hash,record|
        record['body']="here's the body for record #{record['id']}"
        hash["#{tn}_#{record['id']}"] = record
        hash
      }.to_yaml
    end
  end
end
