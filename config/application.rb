require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CogituzApi
  class Application < Rails::Application
    # Custom config for this app
    config.host                = ENV.fetch("HOST")
    config.mercado_pago_id     = ENV.fetch("MERCADO_PAGO_ID")
    config.mercado_pago_secret = ENV.fetch("MERCADO_PAGO_SECRET")
    config.database_username   = ENV["DATABASE_USERNAME"] || 'postgres'
    config.database_password   = ENV["DATABASE_PASSWORD"] || 'postgres'
    config.database_host       = ENV["DATABASE_HOST"] || 'localhost'
    config.database_port       = ENV["DATABASE_PORT"] || 5432
    config.database_name       = ENV["DATABASE_NAME"] || 'cognituz_api_development'
    config.mailgun_key         = ENV["MAILGUN_KEY"] || 'key-47138ef6c5f3fc76f9ace61382ff283a'
    config.mailgun_domain      = ENV["MAILGUN_DOMAIN"] || 'sandbox5a2faf4d9a564760bb2f03073ef1e2c2.mailgun.org'

    config.action_controller.asset_host = config.host
    config.action_mailer.asset_host     = config.host
    config.action_mailer.default_url_options = {host: ENV.fetch('HOST')}

    config.api_only = true

    config.autoload_paths += Dir["#{config.root}/lib/**/"]
    config.autoload_paths += %W(#{config.root}/lib)

    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          headers: :any,
          methods: :any,
          expose: [
            ApiPagination.config.page_header,
            ApiPagination.config.per_page_header,
            ApiPagination.config.total_header
          ]
      end
    end

    config.middleware.use Rack::Deflater
  end
end
