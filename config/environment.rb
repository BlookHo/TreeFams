# Load the Rails application.
require File.expand_path('../application', __FILE__)

Encoding.default_external = Encoding.find("UTF-8")

Time::DATE_FORMATS[:ru_datetime] = "%Y.%m.%d в %k:%M:%S"

# Initialize the Rails application.
Weafam::Application.initialize!

