# Settings specified here will take precedence over those in config/environment.rb

# The production environment is meant for finished, "live" apps.
# Code is not reloaded between requests
config.cache_classes = true

# Use a different logger for distributed setups
# config.logger = SyslogLogger.new

# Full error reports are disabled and caching is turned on
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
#config.action_view.cache_template_loading            = true

# Use a different cache store in production
# config.cache_store = :mem_cache_store

# Enable serving of images, stylesheets, and javascripts from an asset server
# config.action_controller.asset_host                  = "http://assets.example.com"

# Disable delivery errors, bad email addresses will be ignored
# rake db:test:data:load
config.action_mailer.raise_delivery_errors = true
TCRBB_LIST_ADDRESS='rubymn@googlegroups.com'

config.action_mailer.smtp_settings = {
  :address        => "smtp.gmail.com",
  :port           => 587,
  :domain         => "ruby.mn.bot@gmail.com",
  :authentication => :plain,
  :user_name      => "ruby.mn.bot@gmail.com",
  :password       => "thisisanexample" 
}
