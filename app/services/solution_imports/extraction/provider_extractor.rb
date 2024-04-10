# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Provider} records from an import source.
    #
    # @see SolutionImports::Extraction::ExtractProviders
    class ProviderExtractor < SolutionImports::Extraction::BaseExtractor
      include Dry::Effects.State(:extracted_providers)

      def legacy_extract
        names = context.rows.pluck(:provider_name).sort.uniq.compact_blank

        names.each do |name|
          yield add_provider!(name:, identifier: name)
        end

        super
      end

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
