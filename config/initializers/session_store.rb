# Be sure to restart your server when you modify this file.

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
Redstoner::Application.config.session_store :active_record_store

Redstoner::Application.config.session_store :cookie_store,
  key: 'redstoner_session',
  expire_after: 5.days