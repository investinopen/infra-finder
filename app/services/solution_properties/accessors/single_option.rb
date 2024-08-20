# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class SingleOption < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :single_option

      def process_default_csv_value(input)
        vocab.find_term(input).value_or(nil)
      end

      def to_csv
        case vocab.strategy
        in "model"
          super.try(:term)
        else
          # :nocov:
          super
          # :nocov:
        end
      end
    end
  end
end
