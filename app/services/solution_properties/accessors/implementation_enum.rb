# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class ImplementationEnum < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :implementation_enum

      def process_csv_row!
        super

        if csv_strategy == :v2
          impl = ::Implementation.find property.implementation

          assign_value_from_csv!(impl.structured_attr, impl.structured_header)
        end
      end

      def process_default_csv_value(input)
        vocab.find_term(input).value_or("unknown")
      end

      def to_csv
        vocab.mapping.fetch(super, super)
      end
    end
  end
end
