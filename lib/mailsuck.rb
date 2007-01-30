#!/usr/bin/env ruby
#This script can be attached to a mail account
#to automatically create MailList objects in the db.
#be sure to configure the env appropriately.

RAILS_ROOT=File.dirname(__FILE__)+'/../'
RAILS_ENV=ENV["RAILS_ENV"] || 'production'
require 'rubygems'
require 'rmail'
require_gem 'activerecord'
require 'fileutils'
require 'yaml'
require 'pp'
require 'breakpoint'
include RMail::Utils
require_gem  'activerecord'
myconfig = YAML.load(File.open("#{RAILS_ROOT}/config/database.yml"))
ActiveRecord::Base.establish_connection(myconfig[RAILS_ENV])
require "#{RAILS_ROOT}/app/models/list_mail"
def read_msg(io)
  msg = RMail::Parser.read io
  if not msg.multipart?
    msg.decode
  end
  header=msg.header

  lm = ListMail.new
  if( msg.multipart?)
    msg.body.each do|part|
      lm.body+=part.decode if part.header['Content-Type']=~/text\/plain/
    end
  else
    lm.body=msg.body
  end
  lm.subject = header['Subject']
  lm.to = header['To'].nil? ? 'Unknown':header['To']
  lm.from=header['From']
  lm.replyto=header['Reply-to']
  lm.mailid=header['Message-id']
  lm.stamp=header['Date']
  lm.irt=header['In-Reply-To']
  
  unless lm.irt
  lm.save! 
  end

  if lm.irt
    parent = ListMail.find_by_mailid(lm.irt)
    if parent
      lm.parent_id = parent.id
      lm.save!
      parent.add_child lm
      parent.save!
    end
    lm.save!
  end
  lm
end

if(ARGV.empty?)
  msg = read_msg(STDIN)
else
  ARGV.each do |file|
    msg = read_msg(File.open(file))
  end
  ListMail.find(:all).each do |msg|
  end
end
