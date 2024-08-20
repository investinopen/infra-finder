# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Solution} records from an import source.
    #
    # This makes heavy use of the various typed logic in {SolutionProperties::Accessors::AbstractAccessor}.
    #
    # @see SolutionImports::Extraction::ExtractSolutions
    class SolutionExtractor < SolutionImports::Extraction::BaseExtractor
      include Dry::Effects.State(:extracted_solutions)

      def eoi_extract
        context.each_row do |raw_row|
          yield eoi_extract_from raw_row
        end

        super
      end

      def v2_extract
        context.each_row do |raw_row|
          yield v2_extract_from raw_row
        end

        super
      end

      private

      # Finalizer for row extraction methods.
      #
      # @param [{ Symbol => Object }] attrs to instantiate {SolutionImports::Transient::SolutionRow}
      # @return [Dry::Monads::Success(void)]
      def add_row!(**attrs)
        solution_row = SolutionImports::Transient::SolutionRow.new(**attrs)

        logger.debug "Extracted solution: #{solution_row.name}"

        extracted_solutions << solution_row

        Success()
      end

      # Initial row attribute builder for EOI strategy.
      #
      # EOI forms will not come with an identifier column, so we skip that.
      #
      # @param [CSV::Row] row
      # @return [Hash]
      def build_eoi_row_attrs_for(row)
        name_assignment = find_solution_details_in(row)

        prov_assignment = find_provider_details_in(row)

        name = name_assignment.value

        identifier = solution_identifier_for(name)

        provider_identifier = provider_identifier_for(prov_assignment.value)

        { identifier:, provider_identifier:, name:, }
      end

      # Initial row attribute builder for v2 import strategy.
      #
      # They may have an identifier column, so we look for that first
      # when determining an existing solution to affect.
      #
      # @param [CSV::Row] row
      # @return [Hash]
      def build_v2_row_attrs_for(row)
        name_assignment = find_solution_details_in(row)

        prov_assignment = find_provider_details_in(row)

        name = name_assignment.value

        identifier = row[:identifier].presence || solution_identifier_for(name)

        provider_identifier = provider_identifier_for(prov_assignment.value)

        { identifier:, provider_identifier:, name:, }
      end

      # Extract a solution from a CSV row using the EOI strategy.
      #
      # @see #build_eoi_row_attrs_for
      # @param [CSV::Row] row
      # @return [Dry::Monads::Success(void)]
      do_for! def eoi_extract_from(row)
        attrs = build_eoi_row_attrs_for(row)

        attrs[:assignments] = extract_assignments_within(row)

        add_row! **attrs
      end

      # Extract any possible assignments present in the CSV row.
      #
      # @see SolutionProperty
      # @see SolutionProperties::Accessors::AbstractAccessor
      # @param [CSV::Row] row
      # @return [<SolutionProperties::Assignment>]
      def extract_assignments_within(row)
        extraction_accessors.each_with_object([]) do |accessor, assigns|
          assigns.concat accessor.accept_csv!(row)
        end
      end

      # Extract a solution from a CSV row using the v2 strategy.
      #
      # @see #build_v2_row_attrs_for
      # @param [CSV::Row] row
      # @return [Dry::Monads::Success(void)]
      do_for! def v2_extract_from(row)
        attrs = build_v2_row_attrs_for(row)

        attrs[:assignments] = extract_assignments_within(row)

        add_row! **attrs
      end
    end
  end
end
