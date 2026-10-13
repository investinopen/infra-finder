# frozen_string_literal: true

module Types
  # @see Implementations::GraphQLView
  class SolutionImplementationType < Types::BaseObject
    description <<~TEXT
    How a solution implements one practice, such as having a code of conduct.
    TEXT

    field :status, ::Types::ImplementationStatusType, null: true do
      description "How far along the implementation is."
    end

    field :links, [::Types::SolutionImplementationLinkType, { null: false }], null: false do
      description "Supporting links. Implementations that take a single link return at most one."
    end

    field :statement, String, null: true do
      description "A supporting statement, for implementations that take one."
    end
  end
end
