# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class Boolean < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :boolean

      parse_with! Types::Params::Bool.fallback(false)

      # `false` is an answer, so only a missing value is empty.
      def empty_value?(value)
        value.nil?
      end
    end
  end
end
