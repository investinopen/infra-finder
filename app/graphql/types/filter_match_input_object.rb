# frozen_string_literal: true

module Types
  # @abstract For input objects that represent filtering options.
  # @see Filtering::Inputs::ComparatorMatch
  class FilterMatchInputObject < Types::BaseInputObject
    include ::Filtering::SetsStructKlass

    description <<~TEXT
    Filter a value with various constraints. If no values are provided to any
    operator, this filter will be ignored.

    **Note**: The server will _not_ try to check for logical impossibilities,
    e.g. `{ lt: 5, gteq: 10 }`. Input like this will match nothing.
    TEXT

    # @return [Filtering::Inputs::ComparatorMatch, nil]
    def prepare
      struct_klass.new(to_h).presence
    end
  end
end
