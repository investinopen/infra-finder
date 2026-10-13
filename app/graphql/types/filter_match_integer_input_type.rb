# frozen_string_literal: true

module Types
  # @see ::Filtering::Inputs::IntegerMatch
  class FilterMatchIntegerInputType < ::Types::FilterMatchInputObject
    struct_klass_name "Filtering::Inputs::IntegerMatch"

    argument :eq, Int, required: false do
      description "Value to compare with using the `eq` operator."
    end

    argument :not_eq, Int, required: false do
      description "Value to compare with using the `not_eq` operator."
    end

    argument :lt, Int, required: false do
      description "Value to compare with using the `lt` operator."
    end

    argument :lteq, Int, required: false do
      description "Value to compare with using the `lteq` operator."
    end

    argument :gt, Int, required: false do
      description "Value to compare with using the `gt` operator."
    end

    argument :gteq, Int, required: false do
      description "Value to compare with using the `gteq` operator."
    end
  end
end
