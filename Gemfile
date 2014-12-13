source 'https://rubygems.org'
# ruby '2.1.0'

gem 'rails', '4.1.4'

# on mac os x fail:
# gem install pg -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config
gem 'pg'
# gem 'redis-rails'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'spring', group: :development

gem 'jbuilder', '~> 2.0'
gem 'haml-rails'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

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

  # Находит косяки в запросах к базе
  gem "bullet"

  gem 'brakeman', :require => false
  gem 'flog'
  gem 'flay'

  #gem 'mailcatcher' # mail

  #gem 'reek'

end

gem 'activerecord-reset-pk-sequence'

group :development, :test do
  gem 'rspec-rails'
  gem 'capybara'
end

# Disable assets logging
gem 'quiet_assets', :group => :development

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.2'

gem 'capistrano',     '2.15.5', group: :development
gem 'rvm-capistrano', '1.5.1', group: :development

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

#gem "squeel" - sql
