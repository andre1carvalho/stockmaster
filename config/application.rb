require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module App
  class Application < Rails::Application
    config.load_defaults 7.1

    # Carregamento automático de código em lib/
    config.autoload_lib(ignore: %w(assets tasks))

    # Modo API — sem views HTML, só JSON
    config.api_only = true

    # Idioma padrão: Português do Brasil
    config.i18n.default_locale = :"pt-BR"
  end
end
