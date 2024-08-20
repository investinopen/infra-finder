# frozen_string_literal: true

module SolutionImports
  module Extraction
    # @abstract
    class BaseExtractor < SolutionImports::Subprocessor
      include Dry::Core::Memoizable
      include Dry::Effects.Reader(:row_number, default: 1)

      alias csv_strategy strategy

      def perform
        case strategy
        when "eoi"
          yield eoi_extract!

          super
        when "v2"
          yield v2_extract!

          super
        else
          # :nocov:
          Failure[:unsupported_strategy, strategy]
          # :nocov:
        end
      end

      wrapped_hook! :eoi_extract

      wrapped_hook! :v2_extract

      # @!attribute [r] extraction_accessors
      # @return [<SolutionProperties::Accessors::AbstractAccessor>]
      memoize def extraction_accessors
        SolutionProperty.to_extract.map { _1.accessor(csv_strategy:) }
      end

      # @param [CSV::Row] row
      # @return [SolutionProperties::Assignment]
      def find_provider_details_in(row)
        find_assignment_for provider_name_accessor, row
      end

      # @param [CSV::Row] row
      # @return [SolutionProperties::Assignment]
      def find_solution_details_in(row)
        find_assignment_for solution_name_accessor, row
      end

      # @param [SolutionProperties::Accessors::AbstractAccessor] accessor
      # @param [CSV::Row] row
      # @return [SolutionProperties::Assignment]
      def find_assignment_for(accessor, row)
        assign, *_ = accessor.accept_csv!(row)

        if assign.blank? || assign.value.blank?
          # :nocov:
          mark_invalid "Missing required #{accessor.csv_header} value in CSV, can't proceed"

          return
          # :nocov:
        end

        return assign
      end

      # @param [String] name
      # @return [String]
      memoize def provider_identifier_for(name)
        Provider.identifier_by_name(name) || name
      end

      # @!attribute [r] provider_name_accessor
      # @return [SolutionProperty]
      memoize def provider_name_accessor
        SolutionProperty.find("provider_name").accessor(csv_strategy:)
      end

      # Return the stable identifier when importing a {Solution}.
      #
      # It will try to match on an existing {Solution}'s name, but otherwise does nothing.
      #
      # @param [String] name
      # @return [String]
      memoize def solution_identifier_for(name)
        Solution.identifier_by_name(name) || name
      end

      # @!attribute [r] solution_name_accessor
      # @return [SolutionProperty]
      memoize def solution_name_accessor
        SolutionProperty.find("name").accessor(csv_strategy:)
      end
    end
  end
end
