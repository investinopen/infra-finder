# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Organization} records from an import source.
    #
    # @see SolutionImports::Extraction::ExtractOrganizations
    class OrganizationExtractor < SolutionImports::Extraction::BaseExtractor
      include Dry::Effects.State(:extracted_organizations)

      def legacy_extract
        names = context.rows.pluck(:provider_name).sort.uniq.compact_blank

        names.each do |name|
          yield add_organization!(name:, identifier: name)
        end

        super
      end

      private

      # @return [void]
      def add_organization!(name:, identifier: name, **attrs)
        row = SolutionImports::Transient::OrganizationRow.new(identifier:, name:, **attrs)

        extracted_organizations << row

        Success()
      end
    end
  end
end
