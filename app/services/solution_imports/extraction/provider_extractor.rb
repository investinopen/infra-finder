# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Provider} records from an import source.
    #
    # @see SolutionImports::Extraction::ExtractProviders
    class ProviderExtractor < SolutionImports::Extraction::BaseExtractor
      include Dry::Effects.State(:extracted_providers)

      def eoi_extract
        yield v2_extract!

        super
      end

      def v2_extract
        context.each_row do |row|
          yield add_provider_from row
        end

        super
      end

      private

      def add_provider_from(row)
        assignment = find_provider_details_in row

        add_provider! name: assignment.value
      end

      # @return [void]
      def add_provider!(name:, identifier: provider_identifier_for(name), **attrs)
        return Success() if extracted_providers.any? { _1.identifier == identifier }

        row = SolutionImports::Transient::ProviderRow.new(identifier:, name:, **attrs)

        extracted_providers << row

        Success()
      end
    end
  end
end
