Redstoner::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.action_controller.perform_caching = true

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Print deprecation notices to the logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  config.assets.debug = true

  config.eager_load = false

  config.action_mailer.raise_delivery_errors = true

  config.action_mailer.default_url_options = {
    host: 'local.redstoner.com',
    port: 3000
  }

  config.action_mailer.smtp_settings = {
    address:        ENV["SMTP_ADDRESS"],
    port:           ENV["SMTP_PORT"],
    domain:         "redstoner.com",
    authentication: ENV["SMTP_AUTH"],
    user_name:      ENV["SMTP_USERNAME"],
    password:       ENV["SMTP_PASSWORD"],
  }

end
