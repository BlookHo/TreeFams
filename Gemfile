source 'https://rubygems.org'
ruby '2.1.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.2'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass', '~> 3.2.18'
gem 'sass-rails', '~> 4.0.0'
gem 'compass-rails'
gem 'bootstrap-sass'
gem 'haml'

gem "font-awesome-rails"

gem 'russian', '~> 0.6.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Обмен переменными Ruby -> JS
gem 'gon'

# Extend hash
gem 'hashie'


# Yandex inflection
gem "yandex_inflect", "~> 0.1.2"
# КТО      ЧТО     0
# НЕТ КОГО ЧЕГО    1
# КОМУ     ЧЕМУ    2
# КОГО     ЧТО     3
# КЕМ      ЧЕМ     4
# О КОМ    О ЧЕМ   5
#@inflected_word = YandexInflect.inflections(word)#[3]#["__content__"]   # DEBUGG_TO_VIEW



# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'jquery-turbolinks'
#gem 'turbolinks'

gem 'kaminari'


# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # Документация
  gem 'yard'
end


group :development do
  # Лучше отображает ошибки
  gem "better_errors"
  gem "binding_of_caller"

  # Ловит письма для отладки
  #gem 'mailcatcher'

  # Находит косяки в запросах к базе
  gem "bullet"
end

gem 'activerecord-reset-pk-sequence'

# Redis
gem 'redis-rails'

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
  #gem "watir-rspec"
end

# Disable assets logging in production
gem 'quiet_assets', :group => :development

#
# gem 'devise', github: 'plataformatec/devise'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# If ancsi errors:
# export LANG=en_US.UTF-8
# export LC_ALL="en_US.UTF-8"
# gem 'capistrano', '~> 3.0', require: false, group: :development
# group :development do
#   gem 'capistrano-rvm',   '~> 0.1', require: false
#   gem 'capistrano-rails',   '~> 1.1', require: false
#   gem 'capistrano-bundler', '~> 1.1', require: false
# end

gem 'capistrano',     '2.15.5', group: :development
gem 'rvm-capistrano', '1.5.1', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Админка
gem 'rails_admin'
