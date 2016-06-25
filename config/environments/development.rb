Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true




  # Twitter configurations
  config.twitter_key = "8Cjg53yivB3vv3Odw2X85dDfs"
  config.twitter_secret = "fYTDXPC3iIN86sdvzZpYXBj6tvuGKvQTjHUcQR9wd9d14qDR6x"
  config.access_token = "742850285714952192-ON7KA0QAPXNakx9PHhYirYDIUYP2zlk"
  config.access_token_secret = "Dr2sVHNQt1ZgDZ3yljxGcWvkz64mKZleamKrZ9BD2EnQN"

  # Facebook configuration
  config.facebook_access_token = 'EAABotInREWUBAIDlrcHt9SrTVo5ELhMKB5i7Q1OaRrBZBah6HVNZAEaYecZCgHYSYiy2JoHem3w0YBTyP3VCG6ebsMfrZASrRr2k7rT4PId470xdzuRFfYT3dUvFcHftHfIjUtE4UZCZBLN10Iml1Uetvf7yO8huDubcT87jZAZCoQZDZD'


end
