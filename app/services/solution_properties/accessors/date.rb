# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class Date < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :date

      parse_with! Types::AnyDate.optional

      def to_csv
        super&.iso8601
      end
    end
  end
end
