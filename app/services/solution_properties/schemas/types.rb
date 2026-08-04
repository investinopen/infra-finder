# frozen_string_literal: true

module SolutionProperties
  module Schemas
    module Types
      include Dry.Types

      extend Support::EnhancedTypes

      include ::Solutions::Types

      OptionalString = Coercible::String.optional

      OptionalID = String.constrained(filled: true).optional.fallback(nil)

      OptionalIDs = Array.of(OptionalID).constructor do |value|
        case value
        when ::Array
          value
        when ::String
          value.split(/\s*,\s*/).map(&:strip).compact_blank
        else
          Kernel.Array(value)
        end.flatten.map { |elm| OptionalID[elm] }.compact_blank
      end.optional

      NestedAttributeList = ->(inner_type) do
        list_type = Array.of(inner_type).optional

        hash_type = Hash.map(Any, Any)

        (list_type | hash_type).optional
      end
    end
  end
end
