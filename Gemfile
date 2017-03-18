source 'http://rubygems.org'

gem 'rails', github: 'rails/rails', branch: '4-2-stable'

gem 'mysql2'
gem 'jquery-rails'
gem 'bcrypt', platforms: :ruby
gem 'bcrypt-ruby', '3.1.5', :require => 'bcrypt'
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
  # windows timezone foo
  gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw]
end

group :test do
  gem 'sqlite3'
end