require_relative 'boot'

require 'rails/all'

Bundler.require *Rails.groups

module FallacyMania
  class Application < Rails::Application

    config.generators.assets   = false
    config.generators.helper   = false
    config.generators.jbuilder = false

    config.i18n.available_locales = %i(en ru)
    config.i18n.fallbacks = true

    console do
      require 'awesome_print'
      AwesomePrint.irb!
    end

    config.active_record.raise_in_transactional_callbacks = true
  end
end
