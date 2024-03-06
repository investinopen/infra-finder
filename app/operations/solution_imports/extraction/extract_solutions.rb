# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Solution} records from an import source.
    #
    # @api private
    # @see SolutionImports::Extraction::SolutionExtractor
    class ExtractSolutions < Support::SimpleServiceOperation
      service_klass SolutionImports::Extraction::SolutionExtractor
    end
  end
end
