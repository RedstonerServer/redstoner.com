source 'https://rubygems.org'

gem 'rails', github: 'rails/rails', branch: '4-2-stable'

gem 'mysql2'
gem 'jquery-rails'
gem 'bcrypt' # To use ActiveModel's has_secure_password
gem 'sanitize'
gem 'strip_attributes'
gem 'redcarpet'
gem 'hirb' # pretty console output
gem 'rb-readline'
gem 'rest-client'
gem 'activerecord-session_store'
gem 'highlight_js-rails', github: 'RedstonerServer/highlight_js-rails'
gem 'kaminari', github: 'jomo/kaminari', branch: 'patch-2' # pagination
gem 'jquery-textcomplete-rails', github: 'RedstonerServer/jquery-textcomplete-rails' # @mentions
gem 'actionpack-action_caching', github: 'antulik/actionpack-action_caching', ref: '8c6e52c69315d67437f480da5dce4b7c8737fb32'
gem 'mail-gpg', github: 'jomo/mail-gpg', ref: 'a666b48ee866dfa3eaa700f9c5edf4d195d0f8c9'

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
  gem 'tzinfo-data', platforms: [:mingw, :mswin]
end

group :test do
  gem 'sqlite3'
end

group :production do
  # Use unicorn as the app server
  gem 'unicorn'
end
