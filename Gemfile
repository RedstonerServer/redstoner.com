source 'https://rubygems.org'

gem 'rails', '4.1.0'

gem 'mysql2'
gem 'jquery-rails'
gem 'bcrypt-ruby' # To use ActiveModel's has_secure_password
gem 'sanitize'
gem 'strip_attributes'
gem 'redcarpet', '~> 3.2.3'
gem 'hirb' # pretty console output
gem 'rb-readline'
gem 'rest-client'
gem 'activerecord-session_store'
gem 'highlight_js-rails', github: 'RedstonerServer/highlight_js-rails'
gem 'kaminari', github: 'jomo/kaminari', branch: 'patch-2' # pagination
gem 'jquery-textcomplete-rails', github: 'RedstonerServer/jquery-textcomplete-rails' # @mentions

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

group :development do
  gem 'webrick'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'rails-erd'
  # deploy with capistrano
  gem 'capistrano-rails', '~> 1.1.2'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-bundler', '~> 1.1.3'
end

# Use unicorn as the app server
gem 'unicorn'