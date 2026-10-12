# frozen_string_literal: true

require "spec_helper"

return unless ENV["RAILS_ENV"] == "test"

require "simplecov"

SimpleCov.start "rails" do
  enable_coverage :branch

  groups.delete "Channels"
  groups.delete "Libraries"

  group "Admin", "app/admin"
  group "Operations", "app/operations"
  group "Policies", "app/policies"
  group "Services", "app/services"
  group "Uploaders", "app/uploaders"

  # VOG framework filters
  skip "app/channels"
  skip "app/models/concerns/association_helpers"
  skip "app/models/concerns/assigns_polymorphic_foreign_key.rb"
  skip "app/models/concerns/checks_before_destruction.rb"
  skip "app/models/concerns/defines_monadic_operation.rb"
  skip "app/models/concerns/filterable.rb"
  skip "app/models/concerns/has_autoincrementing_identifier.rb"
  skip "app/models/concerns/has_calculated_system_slug"
  skip "app/models/concerns/has_email.rb"
  skip "app/models/concerns/has_unique_identifier"
  skip "app/models/concerns/has_unique_title"
  skip "app/models/concerns/improved_querying.rb"
  skip "app/models/concerns/indexed_searchable"
  skip "app/models/concerns/instance_lockable"
  skip "app/models/concerns/lazy_ordering"
  skip "app/models/concerns/limit_to_one.rb"
  skip "app/models/concerns/scopes_for_title"
  skip "app/models/concerns/standard_transition.rb"
  skip "app/models/concerns/store_model_introspection.rb"
  skip "app/models/concerns/timestamp_scopes.rb"
  skip "app/models/concerns/tracks_mutations"
  skip "app/models/concerns/where_matches.rb"
  skip "app/operations/authorization/authorize"
  skip "app/operations/models"
  skip "app/operations/testing"
  skip "app/operations/utility"
  skip "app/policies/application_policy"
  skip "app/services/application_contract"
  skip "app/services/concerns/calls_common_operation.rb"
  skip "app/services/concerns/initializer_options.rb"
  skip "app/services/concerns/monadic_find.rb"
  skip "app/services/concerns/monadic_persistence.rb"
  skip "app/services/concerns/monadic_transitions.rb"
  skip "app/services/concerns/query_operation.rb"
  skip "app/services/concerns/state_machine_select_options.rb"
  skip "app/services/concerns/transactional_call.rb"
  skip "app/services/testing"
  skip "app/services/tus_client"
  skip "app/services/utility/hash_decamelizer.rb"
  skip "app/validators/enforced_string_validator.rb"
  skip "app/validators/unique_items_validator.rb"
  skip "config/initializers"
  skip "lib/cops"
  skip "lib/generators"
  skip "lib/global_types/array_types.rb"
  skip "lib/global_types/property_hash.rb"
  skip "lib/global_types/indifferent_hash.rb"
  skip "lib/middleware/upload_auth_middleware.rb"
  skip "lib/namespaces"
  skip "lib/patches"
  skip "lib/support"

  # App-specific filters
  skip "app/components/tag_list_component.rb"
  skip "app/components/tag_component.rb"
  skip "app/operations/system/set_bucket_lifecycle.rb"
  skip "app/services/system/asset_pusher.rb"

  # Deprecated
  skip "app/admin/solution_editor_assignments.rb"
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

Shrine.logger = Logger.new(File::NULL)

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
Rails.root.glob('spec/support/**/*.rb').each { |f| require f }

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

  config.after do
    RequestStore.store.clear
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
  config.include Turbo::TestAssertions, type: :request

  config.include ViewComponent::TestHelpers, type: :component
  config.include ViewComponent::SystemTestHelpers, type: :component

  config.include Warden::Test::Helpers
end
