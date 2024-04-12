require_relative 'boot'

require 'rails/all'
require 'dotenv/load'

Bundler.require(*Rails.groups)

module Myapp
  class Application < Rails::Application
    config.load_defaults 5.2
  end
end
