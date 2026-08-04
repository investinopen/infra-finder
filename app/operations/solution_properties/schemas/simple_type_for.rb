# frozen_string_literal: true

module SolutionProperties
  module Schemas
    class SimpleTypeFor
      extend Dry::Core::Cache

      # @param [Class<Support::EnhancedStoreModel>] input
      # @return [Dry::Types::Type]
      def call(input)
        fetch_or_store(:simple_type_for, input) do
          derive_simple_type_for(input)
        end
      end

      private

      # @param [Class<Support::EnhancedStoreModel>] input
      # @return [Dry::Types::Type]
      def derive_simple_type_for(input)
        case input
        in Class => klass if klass < Support::EnhancedStoreModel
          simple_store_model_type_for(klass)
        else
          raise ArgumentError, "Unsupported input type: #{input.class.name}"
        end
      end

      # @param [Class<Support::EnhancedStoreModel>] klass
      # @return [Dry::Types::Type]
      def simple_store_model_type_for(klass)
        schema = klass.attribute_names.map do |key|
          :"#{key}?"
        end.index_with { Types::Any }

        Types::Hash.schema(**schema).with_key_transform(&:to_sym)
      end
    end
  end
end
