# encoding: utf-8
Encoding.default_external = "UTF-8"

Weafam::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  config.action_mailer.default :charset => "utf-8"
  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.perform_deliveries = true

  config.action_mailer.default_url_options = { :host => 'localhost', port: '3000' }  #Bl
  #config.action_mailer.default_url_options = { :host => 'localhost:3000' }

  config.action_mailer.delivery_method = :smtp #Bl

  config.action_mailer.smtp_settings =
      {
       :port => 25, # 1025     -  Bl
       #    :port => 587, # 465, 25
      :enable_starttls_auto => true,  #
      #:address => "smtp.gmail.com",       ########### CHANGE!!
      :address => "smtp.yandex.ru",       ########### CHANGE!!
      #:address => "smtp",       ########### CHANGE!! ??
      :domain => 'localhost:3000',
      #:user_name => 'blookho@gmail.com',  ########### CHANGE!!
      #:password => '',                ########### CHANGE new passw!!
      :user_name => 'weallfamily@yandex.ru',  ########### CHANGE!!
      :password => 'interweb',                ########### CHANGE new passw!!
      :authentication => 'plain',
      :openssl_verify_mode  => 'none' # ??
     }

  # For Mailcatcher
  #config.action_mailer.smtp_settings = { :address => "localhost", :domain => 'localhost:3000', :port => 1025 }
  #config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }


  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  # SpeedUp js / css compiling in development
  config.assets.debug = true
  config.assets.js_compressor = false
  # Expands the lines which load the assets
  config.assets.debug = true

  # Do not compress assets
  #config.assets.compress = false

  #config.assets.css_compressor = :yui
  #config.assets.js_compressor = :uglify
  #config.assets.compile = false

end
