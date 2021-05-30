require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "enju_biblio"
require "enju_leaf"
require "enju_message"
require 'resque/server'

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.i18n.fallbacks = [:en]
    config.i18n.default_locale = :en
  end
end

