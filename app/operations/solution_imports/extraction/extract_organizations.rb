# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Organization} records from an import source.
    #
    # @api private
    # @see SolutionImports::Extraction::OrganizationExtractor
    class ExtractOrganizations < Support::SimpleServiceOperation
      service_klass SolutionImports::Extraction::OrganizationExtractor
    end
  end
end
