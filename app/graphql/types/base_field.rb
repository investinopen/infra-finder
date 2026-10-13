# frozen_string_literal: true

module Types
  # @abstract The base field type used throughout the schema.
  class BaseField < GraphQL::Schema::Field
    prepend ActionPolicy::GraphQL::AuthorizedField

    argument_class Types::BaseArgument
  end
end
