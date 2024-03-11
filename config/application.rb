# frozen_string_literal: true

require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
# require "rails/test_unit/railtie"

require "good_job/engine"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# require_relative "../lib/patches/disable_synchronize"
require_relative "../lib/patches/alter_store_model_mutation_tracking"
require_relative "../lib/patches/better_migration_timestamps"
require_relative "../lib/patches/handle_weird_redis_openssl_errors"
require_relative "../lib/patches/improve_stimulus_manifests"
require_relative "../lib/patches/irregular_camelization"
require_relative "../lib/patches/support_calculated_fields_with_aggregates"
require_relative "../lib/patches/support_lquery"
require_relative "../lib/patches/support_regconfig"
require_relative "../lib/patches/support_websearch"

require_relative "../lib/support/system"

module InfraFinder
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    config.active_record.schema_format = :sql

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w(assets cops frozen_record generators global_types patches support tasks templates))

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.eager_load_paths << Rails.root.join("app", "operations")
    config.eager_load_paths << Rails.root.join("app", "services")

    # Don't generate system test files.
    config.generators.system_tests = nil
    config.generators do |g|
      g.helpers false
      g.integration_specs false

      g.orm :active_record, primary_key_type: :uuid
    end

    config.view_component.component_parent_class = "ApplicationComponent"
    config.view_component.generate.distinct_locale_files = true
    config.view_component.generate.locale = true
    config.view_component.generate.preview = true
    config.view_component.generate.sidecar = true
    config.view_component.generate.stimulus = true
    config.view_component.generate.stimulus_controller = true
    config.view_component.generate.preview_path = "spec/components/previews"
    config.view_component.preview_paths << Rails.root.join("spec/components/previews").to_s
    config.view_component.show_previews_source = false

    if Rails.env.development?
      config.hosts << "www.example.com"
      config.hosts << /[a-z0-9.-]+\.ngrok\.io/
      config.hosts << /[a-z0-9.-]+\.ngrok-free\.app/
    end
  end
end
