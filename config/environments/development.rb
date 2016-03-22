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

  config.action_mailer.default_url_options = { :host => 'localhost', port: '3003' }  #Bl
  #config.action_mailer.default_url_options = { :host => 'localhost:3003' }

  config.action_mailer.delivery_method = :smtp #Bl

  # For Mailcatcher
  #config.action_mailer.smtp_settings = { :address => "localhost", :domain => 'localhost:3003', :port => 1025 }
  #config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }
#  config.action_mailer.smtp_settings = { :address => "localhost", :port => 1025 }

  config.action_mailer.smtp_settings =
      {
       :port => 465 ,  # yandex
           #25,
       # :port =>  1025, #    -  mailcatcher
       # :port =>  587, # - gmail
      :enable_starttls_auto => true,  #
      # :address => "smtp.gmail.com",       ## CHANGE for Gmail
      :address => "smtp.yandex.ru",       ## for Yandex
      :domain => 'localhost:3003',
       # :user_name => 'blookho@gmail.com',  ########### CHANGE!!
       # :password => '1219dmkv1219',                ########### CHANGE new passw!!
      :user_name => 'notification@weallfamily.ru',  ########### CHANGE!!
      :password => '32d2h990',                ########### CHANGE new passw!!
      :authentication => 'plain',
      # :openssl_verify_mode  => 'none' # gmail
      :ssl => true  # yandex
     }



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
  # config.assets.debug = true

  # Do not compress assets
  #config.assets.compress = false

  #config.assets.css_compressor = :yui
  #config.assets.js_compressor = :uglify
  #config.assets.compile = false

  # The notifier of Bullet is a wrap of uniform_notifier
  config.after_initialize do
    Bullet.enable = true
    Bullet.alert = false
    Bullet.bullet_logger = false
    Bullet.console = false
    # Bullet.growl = true
    # Bullet.xmpp = { :account  => 'bullets_account@jabber.org',
    #                 :password => 'bullets_password_for_jabber',
    #                 :receiver => 'your_account@jabber.org',
    #                 :show_online_status => true }
    Bullet.rails_logger = false
    # Bullet.bugsnag = true
    # Bullet.airbrake = true
    Bullet.add_footer = false
    # Bullet.stacktrace_includes = [ 'your_gem', 'your_middleware' ]
  end
  #   The code above will enable all seven of the Bullet notification systems:
  #
  #   Bullet.enable: enable Bullet gem, otherwise do nothing
  #   Bullet.alert: pop up a JavaScript alert in the browser
  #   Bullet.bullet_logger: log to the Bullet log file (Rails.root/log/bullet.log)
  #   Bullet.rails_logger: add warnings directly to the Rails log
  #   Bullet.bugsnag: add notifications to bugsnag
  #   Bullet.airbrake: add notifications to airbrake
  #   Bullet.console: log warnings to your browser's console.log (Safari/Webkit browsers or Firefox w/Firebug installed)
  # Bullet.growl: pop up Growl warnings if your system has Growl installed. Requires a little bit of configuration
  # Bullet.xmpp: send XMPP/Jabber notifications to the receiver indicated. Note that the code will currently not handle
  #   the adding of contacts, so you will need to make both accounts indicated know each other manually before you will
  #   receive any notifications. If you restart the development server frequently, the 'coming online' sound for
  #   the Bullet account may start to annoy - in this case set :show_online_status to false; you will still get
  #   notifications, but the Bullet account won't announce it's online status anymore.
  # Bullet.raise: raise errors, useful for making your specs fail unless they have optimized queries
  # Bullet.add_footer: adds the details in the bottom left corner of the page
  # Bullet.stacktrace_includes: include paths with any of these substrings in the stack trace, even if they are
  #   not in your main app

  # Bullet log log/bullet.log


end
