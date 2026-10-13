# frozen_string_literal: true

module Types
  # An error for a specific attribute/input in a mutation—intended for use with react-hook-form and similarly shaped structures
  #
  # @see VOGMutations::Error
  class MutationAttributeErrorType < Types::BaseObject
    description <<~TEXT
    An error for a specific attribute in a mutation—intended for use
    with react-hook-form and similarly shaped structures.
    TEXT

    field :path, String, null: false do
      description "The attribute that should have the error"
    end

    field :type, String, null: false do
      description "A grouping type for the attribute"
    end

    field :messages, [String, { null: false }], null: false do
      description "The accumulated messages for this combination of path and type"
    end
  end
end
