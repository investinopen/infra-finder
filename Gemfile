# frozen_string_literal: true

source "https://rubygems.org"

ruby "3.3.12"

# STDLIB
gem "csv", "~> 3"
gem "observer"
gem "sorted_set", "~> 1"

# Rails / Database
gem "rails", "~> 7.1.6"
gem "pg", "~> 1.5"
gem "pg_query", "~> 6.2"
gem "activerecord-cte", "~> 0.3"
gem "active_record_distinct_on", "~> 1.6"
gem "active_snapshot", "~> 0.4"
gem "after_commit_everywhere", "~> 1.3"
gem "closure_tree", "~> 7.4"
gem "friendly_id", "~> 5.5"
gem "frozen_record", "~> 0.27"
gem "retryable", "~> 3.0"
gem "scenic", "~> 1.9"
gem "store_model", "~> 4.6"
gem "view_component", "~> 3.11"

# Redis / Jobs
gem "good_job", "~> 3.26"
gem "redis", "~> 5.4"
gem "redis-actionpack", "~> 5.5"
gem "job-iteration", "~> 1.12"

# dry-rb
gem "dry-auto_inject", "~> 1.2"
gem "dry-container", "~> 0.11"
gem "dry-core", "~> 1.2"
gem "dry-effects", "~> 0.5"
gem "dry-files", "~> 1.1"
gem "dry-initializer", "~> 3.2"
gem "dry-matcher", "~> 1.0"
gem "dry-monads", "~> 1.9"
gem "dry-rails", "~> 0.7"
gem "dry-schema", "~> 1.15"
gem "dry-struct", "~> 1.8"
gem "dry-system", "~> 1.2"
gem "dry-transformer", "~> 1.0"
gem "dry-types", "~> 1.9"
gem "dry-validation", "~> 1.11"

# Assets
gem "cssbundling-rails"
gem "heroicon", "~> 1.0.0"
gem "jsbundling-rails"
gem "propshaft"
gem "stimulus-rails"
gem "turbo-rails"

# Misc
gem "absolute_time", "~> 1.0"
gem "active_link_to", "~> 1.0"
gem "acts_as_list", "~> 1.1"
gem "acts-as-taggable-on", "~> 10.0"
gem "activeadmin", "~> 3.2"
gem "addressable", ">= 2.8"
gem "anyway_config", "~> 2.8"
gem "bcrypt", "~> 3.1"
gem "countries", "~> 6.0"
gem "devise", "~> 4.9"
gem "hashdiff", "~> 1.2"
gem "money-rails", "1.15"
gem "nokogiri", "~> 1.19"
gem "noticed", "~> 3.0"
gem "oj", "~> 3.16"
gem "pg_search", "~> 2.3"
gem "premailer", "~> 1.27"
gem "premailer-rails", "~> 1.12"
gem "pundit", "~> 2.2.0"
gem "request_store", "~> 1.7.0"
gem "rolify", "~> 6.0"
gem "sqids", "~> 0.2"
gem "statesman", "~> 10.2"
gem "strip_attributes", "~> 2.0"
gem "tzinfo", "~> 2.0"
gem "validate_url", "~> 1.0"
gem "zaru", "~> 1.0"

# File processing
gem "aws-sdk-s3", "~> 1.136"
gem "content_disposition", "~> 1.0"
gem "ffi", "~> 1.16"
gem "image_processing", "~> 1.14"
gem "marcel"
gem "shrine", "~> 3.6"
gem "shrine-url", "~> 2.4"

# Server / Ruby
gem "bootsnap", "~> 1.22", require: false
gem "pry-rails", "~> 0.3"
gem "puma", "~> 6.4"
gem "rack-cors", "~> 3.0"
gem "rollbar", "~> 3.7"
gem "sucker_punch", "~> 3.3"

group :development do
  gem "rubocop", "1.56.4"
  gem "rubocop-rails", "2.24.0", require: false
  gem "rubocop-rspec", "2.24.1", require: false
  gem "ruby-prof", require: false
  gem "stackprof", require: false
  gem "web-console"
end

group :development, :test do
  gem "erb_lint", "~> 0.5", require: false
  gem "factory_bot_rails", "~> 6.2"
  gem "faker", "~> 3.6"
  gem "rspec", "~> 3.13"
  gem "rspec-rails", "~> 6.1"
  gem "yard", "~> 0.9"
  gem "yard-activerecord"
  gem "yard-activesupport-concern"
end

group :test do
  gem "database_cleaner-active_record", "~> 2.1"
  gem "database_cleaner-redis", "~> 2.0"
  gem "pundit-matchers", "~> 3.1"
  gem "rspec-collection_matchers", "~> 1.2"
  gem "rspec-its"
  gem "rspec-json_expectations", "~> 2.2"
  gem "rspec-parameterized", "~> 2.0"
  gem "simplecov", "~> 0.22", require: false
  gem "test-prof", "~> 1.5"
  gem "timecop", "~> 0.9"
  gem "webmock", "~> 3.26"
end
