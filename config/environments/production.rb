RubyMnWebsite::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  #config.serve_static_assets = false
  config.serve_static_assets = true
  config.static_cache_control = "public, max-age=30758400"

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  #config.assets.compile = false
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  config.assets.js_compressor  = :uglifier
  config.assets.css_compressor = :scss

  # Defaults to Rails.root.join("public/assets")
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store
  config.cache_store = :dalli_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )
  config.assets.precompile += [ /\w+\.(?!js|css).+/, "application.js", "application.css", "ie.css" ]

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false
  # Needed on Heroku Cedar stack
  # http://devcenter.heroku.com/articles/sendgrid
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com'
  }
  config.action_mailer.delivery_method = :smtp

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  TCRBB_LIST_ADDRESS   = 'rubymn@googlegroups.com'
  ADMIN_ADDRESS        = 'admin@ruby.mn'
  NOTIFICATION_ADDRESS = 'notifications@ruby.mn'
end
