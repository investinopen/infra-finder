# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Solution} records from an import source.
    #
    # @see SolutionImports::Extraction::ExtractSolutions
    class SolutionExtractor < SolutionImports::Extraction::BaseExtractor
      include Dry::Effects.State(:extracted_solutions)

      include InfraFinder::Deps[
        normalize_legacy_row: "solution_imports.extraction.normalize_legacy_row",
        transform_legacy_row: "solution_imports.extraction.transform_legacy_row",
      ]

      def legacy_extract
        context.rows.each do |raw_row|
          normalized = normalize_legacy_row.(raw_row.to_h)

          transformed = transform_legacy_row.(normalized)

          row = SolutionImports::Transient::SolutionRow.new(transformed)

          extracted_solutions << row
        end

        super
      end
    end
  end
end
