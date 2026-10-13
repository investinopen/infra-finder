# frozen_string_literal: true

module Resolvers
  # A resolver for a {Provider}.
  #
  # @see Provider
  # @see Types::ProviderType
  class ProviderResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsProvider

    applies_policy_scope!

    type ::Types::ProviderType.connection_type, null: false

    resolves_model! ::Provider

    filters_with! ::Filtering::Scopes::Providers
  end
end
