# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {SolutionIntake} records from an import source.
    #
    # @api private
    # @see SolutionImports::Extraction::IntakeExtractor
    class ExtractIntakes < Support::SimpleServiceOperation
      service_klass SolutionImports::Extraction::IntakeExtractor
    end
  end
end
