# frozen_string_literal: true

module Resolvers
  # A resolver for a {Comment}.
  #
  # @see Comment
  # @see Types::CommentType
  class CommentResolver < AbstractResolver
    include Resolvers::Enhancements::PageBasedPagination
    include Resolvers::OrderedAsComment

    applies_policy_scope!

    type ::Types::CommentType.connection_type, null: false

    resolves_model! ::Comment, association_name: :comments
  end
end
