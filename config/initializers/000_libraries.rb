# frozen_string_literal: true

require "base64"
require "i18n"
require "net/http"
require "with_advisory_lock"

require_relative Rails.root.join("lib", "global_types", "array_types")
require_relative Rails.root.join("lib", "global_types", "indifferent_hash")
require_relative Rails.root.join("lib", "global_types", "property_hash")

I18n.backend.eager_load!

[Dry::Schema, Dry::Validation::Contract].each do |lib|
  lib.config.messages.backend = :i18n
  lib.config.messages.load_paths << Rails.root.join("config", "locales", "en.yml").realpath
end

# FrozenRecord::Base.auto_reloading = Rails.env.development?

Oj.optimize_rails
