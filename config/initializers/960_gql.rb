# frozen_string_literal: true

GraphQL::FragmentCache.configure do |config|
  config.cache_store = Rails.cache
end
