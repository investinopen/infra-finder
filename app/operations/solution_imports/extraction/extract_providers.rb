# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Provider} records from an import source.
    #
    # @api private
    # @see SolutionImports::Extraction::ProviderExtractor
    class ExtractProviders < Support::SimpleServiceOperation
      service_klass SolutionImports::Extraction::ProviderExtractor
    end
  end
end
