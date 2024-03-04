# frozen_string_literal: true

require "spec_helper"
ENV["RAILS_ENV"] ||= "test"
require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch

  groups.delete "Channels"
  groups.delete "Helpers"
  groups.delete "Libraries"
  groups.delete "Mailers"

  add_group "Operations", "app/operations"
  add_group "Policies", "app/policies"
  add_group "Services", "app/services"
  add_group "Uploaders", "app/uploaders"

  # VOG framework filters
  add_filter "app/channels"
  add_filter "app/models/concerns/association_helpers"
  add_filter "app/models/concerns/assigns_polymorphic_foreign_key.rb"
  add_filter "app/models/concerns/checks_before_destruction.rb"
  add_filter "app/models/concerns/filterable.rb"
  add_filter "app/models/concerns/has_calculated_system_slug"
  add_filter "app/models/concerns/has_email.rb"
  add_filter "app/models/concerns/has_unique_identifier"
  add_filter "app/models/concerns/has_unique_title"
  add_filter "app/models/concerns/improved_querying.rb"
  add_filter "app/models/concerns/indexed_searchable"
  add_filter "app/models/concerns/instance_lockable"
  add_filter "app/models/concerns/lazy_ordering"
  add_filter "app/models/concerns/limit_to_one.rb"
  add_filter "app/models/concerns/scopes_for_title"
  add_filter "app/models/concerns/store_model_introspection.rb"
  add_filter "app/models/concerns/tracks_mutations"
  add_filter "app/models/concerns/where_matches.rb"
  add_filter "app/operations/authorization/authorize"
  add_filter "app/operations/models"
  add_filter "app/operations/testing"
  add_filter "app/operations/uploads/authorize.rb"
  add_filter "app/operations/variable_precision/parse_date"
  add_filter "app/policies/application_policy"
  add_filter "app/services/application_contract"
  add_filter "app/services/concerns/initializer_options.rb"
  add_filter "app/services/concerns/monadic_find.rb"
  add_filter "app/services/concerns/monadic_transitions.rb"
  add_filter "app/services/concerns/query_operation.rb"
  add_filter "app/services/testing"
  add_filter "app/services/tus_client"
  add_filter "app/services/utility/hash_decamelizer.rb"
  add_filter "app/services/utility/recursive_interface_fragment_builder.rb"
  add_filter "app/services/utility/recursive_union_fragment_builder.rb"
  add_filter "app/services/utility/request_runner"
  add_filter "app/validators/enforced_string_validator.rb"
  add_filter "app/validators/unique_items_validator.rb"
  add_filter "config/initializers"
  add_filter "lib/cops"
  add_filter "lib/generators"
  add_filter "lib/global_types/array_types.rb"
  add_filter "lib/global_types/property_hash.rb"
  add_filter "lib/global_types/indifferent_hash.rb"
  add_filter "lib/middleware/upload_auth_middleware.rb"
  add_filter "lib/namespaces"
  add_filter "lib/patches"
  add_filter "lib/support"

  # App-specific filters
  add_filter "app/operations/example_queries/generate_tei_section_content"
end

require File.expand_path("../config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "rspec/json_expectations"
require "pundit/rspec"
require "pundit/matchers"
require "webmock/rspec"
require "test_prof/recipes/rspec/any_fixture"
require "test_prof/recipes/rspec/let_it_be"

# Add additional requires below this line. Rails is not loaded until this point!

ActiveJob::Base.queue_adapter = :test

Shrine.logger = Logger.new("/dev/null")

Dry::Effects.load_extensions :rspec

require_relative "system/test_container"

TestingAPI::TestContainer.finalize!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join("spec", "support", "**", "*.rb")].each { |f| require f }

# Checks for pending migrations and applies them before tests are run.
# If you are not using ActiveRecord, you can remove these lines.
begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  puts e.to_s.strip
  exit 1
end

Rails.application.eager_load!

RSpec.configure do |config|
  # We use database cleaner to do this
  config.use_transactional_fixtures = false

  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :transaction
    DatabaseCleaner[:redis].strategy = :deletion

    DatabaseCleaner[:active_record].clean_with(:truncation)
    DatabaseCleaner[:redis].clean_with(:deletion)

    Scenic.database.views.select(&:materialized).each do |view|
      Scenic.database.refresh_materialized_view view.name, concurrently: false, cascade: false
    end
  end

  config.before(:suite) do
    WebMock.disable_net_connect!
  end

  config.before(:suite) do
    TestingAPI::TestContainer["initialize_database"].()
  end

  config.after(:context) do
    Faker::UniqueGenerator.clear
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!

  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  config.include ActiveJob::TestHelper

  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Devise::Test::IntegrationHelpers, type: :request

  config.include Warden::Test::Helpers
end
