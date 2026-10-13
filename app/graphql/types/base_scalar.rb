# frozen_string_literal: true

module Types
  # @abstract The base scalar type used throughout the schema.
  class BaseScalar < GraphQL::Schema::Scalar
    include Support::GraphQLAPI::Enhancements::Scalar
  end
end
