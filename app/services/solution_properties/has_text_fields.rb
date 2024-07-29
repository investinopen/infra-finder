# frozen_string_literal: true

module SolutionProperties
  module HasTextFields
    extend ActiveSupport::Concern
    extend DefinesMonadicOperation

    included do
      extend Dry::Core::ClassAttributes

      defines :blurbs, :strings, :urls, type: SolutionProperties::Types::Fields

      blurbs SolutionProperty.blurb_values
      strings SolutionProperty.string_values
      urls SolutionProperty.url_values

      strip_attributes only: strings, allow_empty: false, collapse_spaces: true, replace_newlines: true
      strip_attributes only: blurbs, allow_empty: false, collapse_spaces: true, replace_newlines: false

      normalizes *blurbs, with: -> { _1.gsub("\r", "") }

      before_validation :parse_financial_date_range!
    end

    # @return [void]
    def parse_financial_date_range!
      bounds = parse_date_range!(financial_date_range, prefix: :financial_date_range)

      assign_attributes(bounds)
    end

    # @api private
    monadic_operation! def parse_date_range(input, prefix:)
      call_operation("solution_properties.parse_date_range", input, prefix:)
    end
  end
end
