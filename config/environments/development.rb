# frozen_string_literal: true

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Disable request forgery protection.
  config.action_controller.allow_forgery_protection = false

  # Show full error reports.
  config.consider_all_requests_local = Settings.application.use_local_routes

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Settings.application.perform_caching
    config.action_controller.perform_caching = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control": "public, max-age=#{2.days.to_i}",
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options)
  config.active_storage.service = :local

  # Configure the mailer
  config.action_mailer.default_url_options = { host: Settings.application.host_name }

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Deliver mail if configured to do so.
  config.action_mailer.perform_deliveries = Settings.application.send_email

  # Put files in tmp/mails
  config.action_mailer.delivery_method = :file

  # Should anything be cached?
  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Logstash: Configuration
  config.logstash.type = :file

  # Logstash: Default Rails logging
  config.logstash.formatter = ::Logger::Formatter

  # Logstash: JSON logging (Simulate deployed environments)
  # config.colorize_logging = false
  # config.logstash.formatter = :json_lines
end
