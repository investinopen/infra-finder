# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class ImplementationProperty < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :implementation_property

      def apply_value_to(attr, value)
        implementation = instance.__send__(property.implementation)

        implementation.write_csv_property(property.implementation_property, value)
      end

      def to_csv
        implementation = instance.__send__(property.implementation)

        implementation.read_csv_property(property.implementation_property)
      end
    end
  end
end
