# frozen_string_literal: true

module Structured
  module CSVConversion
    extend ActiveSupport::Concern

    # @return [String]
    def to_csv
      as_json.transform_values do |value|
        cast_to_csv(value)
      end.compact.to_json
    end

    private

    def cast_to_csv(value)
      case value
      when Array
        value.map { cast_to_csv(_1) }.compact_blank
      when Hash
        value.transform_values { cast_to_csv(_1) }.compact
      when false then value
      else
        value.presence
      end
    end
  end
end
