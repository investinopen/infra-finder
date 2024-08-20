# frozen_string_literal: true

module SolutionProperties
  module Accessors
    class StoreModelList < SolutionProperties::Accessors::AbstractAccessor
      property_kind! :store_model_list

      delegate :free_input_property, :structured_attr, :structured_header, to: :property

      delegate :attribute_name, to: :free_input_property, prefix: :free_input

      def process_csv_row!
        assign_value_from_csv!(free_input_attribute_name, csv_header)

        if csv_strategy == :v2
          assign_value_from_csv!(structured_attr, structured_header)
        end
      end

      def to_csv
        instance.__send__(free_input_attribute_name)
      end
    end
  end
end
