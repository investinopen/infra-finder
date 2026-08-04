# frozen_string_literal: true

module SolutionProperties
  module Schemas
    class BuildParams < Support::SimpleServiceOperation
      extend Dry::Core::Cache

      service_klass SolutionProperties::Schemas::ParamsBuilder

      # @return [Dry::Types::Type]
      def actual = schema_for(:actual)

      # @return [Dry::Types::Type]
      def draft = schema_for(:draft)

      # @return [Dry::Types::Type]
      def intake = schema_for(:intake)

      private

      def schema_for(solution_kind)
        fetch_or_store(:schema_for, solution_kind) do
          call(solution_kind:).value!
        end
      end
    end
  end
end
