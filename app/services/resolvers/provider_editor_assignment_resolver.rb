# frozen_string_literal: true

module Resolvers
  # A resolver for a {ProviderEditorAssignment}.
  #
  # @see ProviderEditorAssignment
  # @see Types::ProviderEditorAssignmentType
  class ProviderEditorAssignmentResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsProviderEditorAssignment

    applies_policy_scope!

    type ::Types::ProviderEditorAssignmentType.connection_type, null: false

    resolves_model! ::ProviderEditorAssignment

    filters_with! ::Filtering::Scopes::ProviderEditorAssignments
  end
end
