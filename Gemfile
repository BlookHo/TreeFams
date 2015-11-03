source 'https://rubygems.org'

gem 'rails', '4.1.4'

gem 'thin'

gem 'activerecord-jdbcsqlite3-adapter', platforms: [:jruby]
gem 'activerecord-import'
gem 'coveralls', require: false

# platforms :rbx do
#   gem 'rubysl', '~> 2.0'
#   gem 'rubinius-developer_tools'
# end

# on mac os x fail:
# gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config
gem 'pg'
# gem 'redis-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'\

gem 'jbuilder', '~> 2.0'
gem 'haml-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails', '3.1.1'
gem 'jquery-ui-rails', '4.2.1'

# Angular templates in assets pipeline
gem 'angular-rails-templates'
gem 'ngannotate-rails'


# Icons fonts
gem 'font-awesome-rails', '~> 4.2.0.0'
# gem 'font-awesome-sass', '~> 4.2.0'
gem 'ionicons-rails'


# Russian localization
gem 'russian', '~> 0.6.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer'

# Обмен переменными Ruby -> JS
# gem 'gon'

# Extend hash
gem 'hashie'


gem "paperclip", "~> 4.2"
gem "papercrop"

# Yandex inflection
gem "yandex_inflect", "~> 0.1.2"
# КТО      ЧТО     0
# НЕТ КОГО ЧЕГО    1
# КОМУ     ЧЕМУ    2
# КОГО     ЧТО     3
# КЕМ      ЧЕМ     4
# О КОМ    О ЧЕМ   5
#@inflected_word = YandexInflect.inflections(word)#[3]#["__content__"]   # DEBUGG_TO_VIEW

# Pagination
gem 'kaminari'

group :doc do
  # Документация
  gem 'yard'
end

group :development do
  # Лучше отображает ошибки
  gem "better_errors"
  gem "binding_of_caller"


  gem 'brakeman', :require => false
  gem 'flog'
  gem 'flay'

  #gem 'mailcatcher' # mail

  #gem 'reek'

  # Automagically launches tests for changed files
  gem 'guard'
  gem 'guard-rspec', require: false

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  gem 'spring-commands-rspec'
end

gem 'activerecord-reset-pk-sequence'


group :development, :test do
  # Test framework
  gem 'rspec-rails'
  gem 'rspec-support'
  # gem 'rspec-support', '~> 3.2.1'
  # For active record imitation in tests
  gem 'factory_girl_rails'
end

group :test do
  # Rspec console formatting
  gem 'fuubar'

  # Features tests for Rspec
  gem 'capybara'
  gem 'capybara-ng'

  # Webkit driver for js feature tests
  # $ brew install qt
  # $ sudo apt-get install qt4-dev-tools libqt4-dev libqt4-core libqt4-gui
  gem 'capybara-webkit'

  # To open test pages when save_and_open_page method is called
  gem 'launchy'

  # Enables screenshots creation during tests
  gem 'capybara-screenshot'

  # Auto cleans test db after each test run
  gem 'database_cleaner'

  # Faker, a port of Data::Faker from Perl,
  # is used to easily generate fake data: names, addresses, phone numbers, etc.
  gem 'faker', '~> 1.5'
end

# Disable assets logging
gem 'quiet_assets', :group => :development

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'


gem 'capistrano',     '2.15.5', group: :development, require: false
gem 'rvm-capistrano', '1.5.1', group: :development, require: false

# Use debugger
# gem 'debugger', group: [:development, :test]


gem 'newrelic_rpm'

group :console do
  # does not work !!!
  gem 'pry' #
  gem 'hirb' # даёт прекрасное расположение хэша модели, в стиле mysql.
  gem 'wirble' #   — даёт подсветку.
  gem 'awesome_print', :require => 'ap'
end


gem 'omniauth'
gem 'omniauth-facebook'
gem 'fb_graph'
gem 'omniauth-twitter'
gem 'twitter'#, :git => 'https://github.com/sferik/twitter.git'
gem "omniauth-google-oauth2"
gem "omniauth-vkontakte"
gem 'vkontakte_api'

# Middleware that displays speed badge for every html page. Designed to work both in production and in development.
gem 'rack-mini-profiler'

# Находит косяки в запросах к базе
# help to kill N+1 queries and unused eager loading
gem "bullet", :group => "development"

gem "ruby-growl"
#gem "squeel" - sql

gem 'whenever' , :require => false # v 0.9.4


