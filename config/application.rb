require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'yaml'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ApsContest
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    EMAIL_CONFIG = YAML.load(File.read(File.expand_path('../email.yml', __FILE__)))
    ActionMailer::Base.smtp_settings = {
      address:              EMAIL_CONFIG['address'],
      port:                 EMAIL_CONFIG['port'], 
      domain:               EMAIL_CONFIG['domain'],
      user_name:            EMAIL_CONFIG['user_name'],
      password:             EMAIL_CONFIG['password'],
      authentication:       EMAIL_CONFIG['authentication'],
      enable_starttls_auto: EMAIL_CONFIG['enable_starttls_auto']
    }

    config.generators do |g|
      g.test_framework :rspec,
        :fixtures => true,
        :view_specs => false,
        :helper_specs => false,
        :routing_specs => false,
        :controller_specs => true,
        :request_specs => true

      g.fixture_replacement :factory_girl, :dir => "spec/factories"
    end
  end
end
