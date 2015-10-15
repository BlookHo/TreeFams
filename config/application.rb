# encoding: utf-8

Encoding.default_external = "UTF-8"


require File.expand_path('../boot', __FILE__)

require 'csv' # to CommaSeparatedValues and Excel


require 'rails/all'
require 'date'
require 'time'
#gem ruby-mysql

# Pick the frameworks you want:
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "sprockets/railtie"
# require "rails/test_unit/railtie"

#if defined?(Bundler)
#  # If you precompile assets before deploying to production, use this line
#  Bundler.require(*Rails.groups(:assets => %w(development test)))
#  # If you want your assets lazily compiled in production, use this line
#  # Bundler.require(:default, :assets, Rails.env)
#end


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module Weafam
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.


    # Load abstract class in rails_root/app/models
    config.autoload_paths += Dir[Rails.root.join('app', 'models', 'abstracts')]
    config.autoload_paths += Dir[Rails.root.join('lib', 'added_classes', 'hash_work')]
    config.autoload_paths += Dir[Rails.root.join('lib', 'added_classes', 'circles')]
    config.autoload_paths += Dir[Rails.root.join('lib', 'added_classes', 'service')]


    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de
    config.i18n.default_locale = :ru
    I18n.enforce_available_locales = true
    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
    config.i18n.fallbacks = true
    config.i18n.fallbacks = [:en]

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    config.sass.preferred_syntax = :sass

    config.force_ssl = false    # сделано в целях ухода от Ошибка 107 (net::ERR_SSL_PROTOCOL_ERROR): Ошибка протокола SSL.
    # 25.06.13 - 10-25

    # todo: разобраться, почему это влияет на created_at
    #config.time_zone = 'UTC'
    #config.active_record.default_timezone = 'UTC'

    # Enable the asset pipeline
    config.assets.enabled = true

    #js compression
    config.assets.compress = true
    config.assets.js_compressor = :uglifier

    # Version of your assets, change this if you want to expire all your assets
    config.assets.version = '1.0'

    # чтобы fontAwesome также был в assets
    # config.assets.paths << Rails.root.join("app", "assets", "fonts")
    config.assets.paths << Rails.root.join('app', 'assets', 'fonts', 'sounds')
    config.assets.precompile += %w( .svg .eot .woff .ttf)

    # Не показывать логи assets в development
    config.quiet_assets = true

    ## For Devise
    #config.assets.initialize_on_precompile = false

    # config.cache_store = :redis_store, 'redis://localhost:6379/0/cache'
    # config.session_store :redis_store

    # configure your logger
    # config.logger = ActiveSupport::Logger.new('your_app.log')
    # or
    # config.logger = ActiveSupport::TaggedLogging.new(Logger.new('your_app.log'))

    # роуты для ошибок
    config.exceptions_app = self.routes


  end
end
