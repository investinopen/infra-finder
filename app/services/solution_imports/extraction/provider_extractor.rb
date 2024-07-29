# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Provider} records from an import source.
    #
    # @see SolutionImports::Extraction::ExtractProviders
    class ProviderExtractor < SolutionImports::Extraction::BaseExtractor
      include Dry::Effects.State(:extracted_providers)

      private

      # @return [void]
      def add_provider!(name:, identifier: name, **attrs)
        row = SolutionImports::Transient::ProviderRow.new(identifier:, name:, **attrs)

        extracted_providers << row

        Success()
      end
    end
  end
end
