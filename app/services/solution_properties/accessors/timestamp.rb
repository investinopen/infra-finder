# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class Timestamp < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :timestamp

      parse_with! Types::Params::Time.optional

      def to_csv
        super&.rfc3339
      end
    end
  end
end
