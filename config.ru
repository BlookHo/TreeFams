# This file is used by Rack-based servers to start_enter the application.

require ::File.expand_path('../config/environment',  __FILE__)

# Thin log to console
console = ActiveSupport::Logger.new($stdout)
console.formatter = Rails.logger.formatter
console.level = Rails.logger.level

# Rails.logger.extend(ActiveSupport::Logger.broadcast(console)) # comment this to have one lines and reload


run Rails.application
