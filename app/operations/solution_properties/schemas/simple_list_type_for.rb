# frozen_string_literal: true

module SolutionProperties
  module Schemas
    class SimpleListTypeFor
      extend Dry::Core::Cache

      include InfraFinder::Deps[
        simple_type_for: "solution_properties.schemas.simple_type_for",
      ]

      # @param [Class<Support::EnhancedStoreModel>] input
      # @return [Dry::Types::Type]
      def call(input)
        fetch_or_store(:simple_list_type_for, input) do
          base_type = simple_type_for.(input)

          Types::NestedAttributeList[base_type]
        end
      end
    end
  end
end
