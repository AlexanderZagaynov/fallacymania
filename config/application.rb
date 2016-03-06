require_relative 'boot'

require 'rails/all'

Bundler.require *Rails.groups

module FallacyMania
  class Application < Rails::Application

    cattr_reader(:nickname) { parent_name.demodulize.downcase }

    config.assets.version = '1.0'
    config.logger = Logging.logger['Rails']
    config.filter_parameters << :password
    config.action_dispatch.cookies_serializer = :json
    config.active_record.raise_in_transactional_callbacks = true
    config.session_store :cookie_store, key: "_#{nickname}_session"

    config.i18n.fallbacks = true
    config.i18n.available_locales = %i(en ru)

    config.generators do |g|
      g.assets   = false
      g.helper   = false
      g.jbuilder = false
    end

    console do
      require 'awesome_print'
      AwesomePrint.irb!
    end

  end
end
