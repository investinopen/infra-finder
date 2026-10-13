# frozen_string_literal: true

module Types
  # @see ::Filtering::Inputs::DateMatch
  class FilterMatchDateType < ::Types::FilterMatchObject
    struct_klass_name "Filtering::Inputs::DateMatch"

    field :eq, ::GraphQL::Types::ISO8601Date, null: true do
      description "Value to compare with using the `eq` operator."
    end

    field :not_eq, ::GraphQL::Types::ISO8601Date, null: true do
      description "Value to compare with using the `not_eq` operator."
    end

    field :lt, ::GraphQL::Types::ISO8601Date, null: true do
      description "Value to compare with using the `lt` operator."
    end

    field :lteq, ::GraphQL::Types::ISO8601Date, null: true do
      description "Value to compare with using the `lteq` operator."
    end

    field :gt, ::GraphQL::Types::ISO8601Date, null: true do
      description "Value to compare with using the `gt` operator."
    end

    field :gteq, ::GraphQL::Types::ISO8601Date, null: true do
      description "Value to compare with using the `gteq` operator."
    end
  end
end
