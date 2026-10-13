# frozen_string_literal: true

module Types
  # @see ::Filtering::Inputs::DateMatch
  class FilterMatchDateInputType < ::Types::FilterMatchInputObject
    struct_klass_name "Filtering::Inputs::DateMatch"

    argument :eq, ::GraphQL::Types::ISO8601Date, required: false do
      description "Value to compare with using the `eq` operator."
    end

    argument :not_eq, ::GraphQL::Types::ISO8601Date, required: false do
      description "Value to compare with using the `not_eq` operator."
    end

    argument :lt, ::GraphQL::Types::ISO8601Date, required: false do
      description "Value to compare with using the `lt` operator."
    end

    argument :lteq, ::GraphQL::Types::ISO8601Date, required: false do
      description "Value to compare with using the `lteq` operator."
    end

    argument :gt, ::GraphQL::Types::ISO8601Date, required: false do
      description "Value to compare with using the `gt` operator."
    end

    argument :gteq, ::GraphQL::Types::ISO8601Date, required: false do
      description "Value to compare with using the `gteq` operator."
    end
  end
end
