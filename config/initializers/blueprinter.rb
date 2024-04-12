# frozen_string_literal: true
require_relative '../../app/services/camel_case_transformer.rb'

Blueprinter.configure do |config|
  config.generator = Oj
  config.default_transformers = [CamelCaseTransformer]
end
