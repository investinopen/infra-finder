# frozen_string_literal: true

module Types
  # @abstract For input objects that represent filtering options.
  # @see Filtering::Inputs::ComparatorMatch
  class FilterMatchObject < Types::BaseObject
    include ::Filtering::SetsStructKlass

    description <<~TEXT
    A value with various constraints. If no values are provided to any
    operator, this filter will be ignored.
    TEXT
  end
end
