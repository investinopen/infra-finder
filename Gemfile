# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.2.3"

# STDLIB
gem "csv", "~> 3.2.8"

# Rails / Database
gem "rails", "~> 7.1.3"
gem "pg", "~> 1.5.4"
gem "pg_query", "~> 5.1.0"
gem "activerecord-cte", "~> 0.3.0"
gem "active_record_distinct_on", "~> 1.6.0"
gem "active_snapshot", "~> 0.3.2"
gem "after_commit_everywhere", "~> 1.3.1"
gem "closure_tree", "~> 7.4.0"
gem "friendly_id", "~> 5.5.1"
gem "frozen_record", "~> 0.27.1"
gem "postgresql_cursor", "~> 0.6.8"
gem "retryable", "~> 3.0.5"
gem "scenic", "~> 1.6.0"
gem "store_model", "~> 2.1.2"
gem "view_component", "~> 3.11.0"

# Redis / Jobs
gem "good_job", "~> 3.26.2"
gem "redis", "~> 5.1.0"
gem "redis-actionpack", "~> 5.4.0"
gem "redis-objects", ">= 2.0.0.beta"
gem "job-iteration", "~> 1.4.1"

# dry-rb
gem "dry-auto_inject", "~> 1.0.1"
gem "dry-container", "~> 0.11.0"
gem "dry-core", "~> 1.0.0"
gem "dry-effects", "~> 0.4.1"
gem "dry-files", "~> 0.1.0"
gem "dry-initializer", "~> 3.1.1"
gem "dry-matcher", "~> 1.0.0"
gem "dry-monads", "~> 1.6.0"
gem "dry-rails", "~> 0.7.0"
gem "dry-schema", "~> 1.13.0"
gem "dry-struct", "~> 1.6.0"
gem "dry-system", "~> 1.0.1"
gem "dry-transformer", "~> 1.0"
gem "dry-types", "~> 1.7.1"
gem "dry-validation", "~> 1.10.0"

# Assets
gem "cssbundling-rails"
gem "heroicon", "~> 1.0.0"
gem "jsbundling-rails"
gem "propshaft"
gem "stimulus-rails"
gem "turbo-rails"

# Misc
gem "absolute_time", "~> 1.0.0"
gem "active_link_to", "~> 1.0.5"
gem "acts_as_list", "~> 1.1.0"
gem "acts-as-taggable-on", "~> 10.0"
gem "activeadmin", "~> 3.2.0"
gem "addressable", ">= 2.8.0"
gem "anyway_config", "~> 2.6.3"
gem "bcrypt", "~> 3.1.20"
gem "countries", "~> 6.0.1"
gem "devise", "~> 4.9.3"
gem "email_validator", "~> 2.2.4"
gem "groupdate", "~> 6.2.1"
gem "money-rails", "1.15.0"
gem "nokogiri", "~> 1.16.2"
gem "oj", "~> 3.16.1"
gem "pg_search", "~> 2.3.6"
gem "premailer", "~> 1.27.0"
gem "premailer-rails", "~> 1.12.0"
gem "pundit", "~> 2.2.0"
gem "request_store", "~> 1.7.0"
gem "rolify", "~> 6.0.1"
gem "statesman", "~> 10.2.3"
gem "strip_attributes", "1.13.0"
gem "tzinfo", "~> 2.0.6"
gem "validate_url", "~> 1.0.15"
gem "zaru", "~> 1.0.0"

# File processing
gem "aws-sdk-s3", "~> 1.136.0"
gem "chunky_png", "~> 1.4.0"
gem "content_disposition", "~> 1.0.0"
gem "fastimage", "~> 2.2.6"
gem "ffi", "~> 1.16.3"
gem "image_processing", "~> 1.12.2"
gem "marcel", "~> 1.0.2"
gem "mediainfo", "~> 1.5.0"
gem "shrine", "~> 3.5.0"
gem "shrine-tus", "~> 2.1.1"
gem "shrine-url", "~> 2.4.1"

# Server / Ruby
gem "bootsnap", "~> 1.11.1", require: false
gem "pry-rails", "~> 0.3.9"
gem "puma", "~> 6.4.2"
gem "rack-cors", "~> 2.0.1"
gem "rollbar", "~> 3.5.1"
gem "sucker_punch", "~> 3.2.0"

group :development do
  gem "rubocop", "1.56.4"
  gem "rubocop-rails", "2.24.0", require: false
  gem "rubocop-rspec", "2.24.1", require: false
  gem "ruby-prof", "~> 1.6.3", require: false
  gem "stackprof", "~> 0.2.25", require: false
  gem "web-console"
end

group :development, :test do
  gem "erb_lint", "~> 0.5.0", require: false
  gem "factory_bot_rails", "~> 6.2.0"
  gem "faker", "~> 3.2.3"
  gem "rspec", "~> 3.13.0"
  gem "rspec-rails", "~> 6.1.1"
  gem "yard", "~> 0.9.34"
  gem "yard-activerecord", "~> 0.0.16"
  gem "yard-activesupport-concern", "~> 0.0.1"
end

group :test do
  gem "database_cleaner-active_record", "~> 2.1.0"
  gem "database_cleaner-redis", "~> 2.0.0"
  gem "pundit-matchers", "~> 3.1.2"
  gem "rspec-collection_matchers", "~> 1.2.0"
  gem "rspec-json_expectations", "~> 2.2.0"
  gem "simplecov", "~> 0.22.0", require: false
  gem "test-prof", "~> 1.2.3"
  gem "timecop", "~> 0.9.8"
  gem "webmock", "3.19.1"
end
