# frozen_string_literal: true

module SolutionImports
  module Extraction
    # Extract transient {Solution} records from an import source.
    #
    # This makes heavy use of the various typed logic in {SolutionProperties::Accessors::AbstractAccessor}.
    #
    # @see SolutionImports::Extraction::ExtractIntakes
    class IntakeExtractor < SolutionImports::Extraction::BaseExtractor
      include Dry::Effects.State(:extracted_intakes)

      def intake_extract
        context.each_row do |raw_row|
          yield intake_extract_from raw_row
        end

        super
      end

      private

      # Finalizer for row extraction methods.
      #
      # @param [{ Symbol => Object }] attrs to instantiate {SolutionImports::Transient::IntakeRow}
      # @return [Dry::Monads::Success(void)]
      def add_row!(**attrs)
        intake_row = SolutionImports::Transient::IntakeRow.new(**attrs)

        logger.debug "Extracted intake: #{intake_row.name}"

        extracted_intakes << intake_row

        Success()
      end

      # Initial row attribute builder for jotform intake pre-fills strategy.
      #
      # Jotform intake pre-fills will not come with an identifier column, so we skip that.
      #
      # They may also not include a provider (necessitating the admins to populate them manually.)
      #
      # @param [CSV::Row] row
      # @return [Hash]
      def build_intake_row_attrs_for(row)
        name_assignment = find_solution_details_in(row)

        prov_assignment = find_provider_details_in(row, required: false)

        name = name_assignment.value

        identifier = solution_identifier_for(name)

        provider_identifier = provider_identifier_for(prov_assignment&.value)

        { identifier:, provider_identifier:, name:, }
      end

      # Extract a solution from a CSV row using the jotform intake pre-fills strategy.

      # @see #build_intake_row_attrs_for
      # @param [CSV::Row] row
      # @return [Dry::Monads::Success(void)]
      do_for! def intake_extract_from(row)
        attrs = build_intake_row_attrs_for(row)

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
    end
  end
end
