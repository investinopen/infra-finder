# frozen_string_literal: true

module SolutionProperties
  module Accessors
    # @abstract
    class AbstractAccessor
      extend Dry::Core::ClassAttributes
      extend Dry::Initializer

      include Dry::Effects.Reader(:csv_row)
      include Dry::Effects::Handler.Reader(:csv_row)

      include Dry::Effects.Reader(:instance)
      include Dry::Effects::Handler.Reader(:instance)

      include Dry::Effects.State(:assignments)
      include Dry::Effects::Handler.State(:assignments)

      include Dry::Effects.Interrupt(:skip_assignment)
      include Dry::Effects::Handler.Interrupt(:skip_assignment, as: :catch_skipped_assignment)

      defines :property_kind_name, type: Types::Kind.optional
      defines :csv_parse_type, type: Support::Types::DryType

      csv_parse_type Types::Any

      param :property, Types.Instance(::SolutionProperty)

      option :csv_strategy, Types::CSVStrategy, default: -> { :modern }

      TERM_SEPARATOR = " | "

      TERM_SPLITTER = /\s*\|\s*/

      delegate :property_kind, :property_kind_name, to: :class
      delegate :attribute_name, :connection_mode, :csv_header, :vocab, to: :property
      delegate :solution_kind, to: :solution

      # @!group Interface

      # @param [Solution, SolutionDraft] instance
      # @param [SolutionProperties::Assignment] assignment
      # @return [void]
      def apply_assignment!(instance, assignment)
        with_instance! instance do
          apply_assignment assignment
        end
      end

      # @param [Solution, SolutionDraft] instance
      # @param [Object] value
      # @return [void]
      def apply_value!(instance, value)
        with_instance! instance do
          apply_value(value)
        end
      end

      # @param [CSV::Row] row
      # @return [Dry::Types::Any]
      def accept_csv!(row)
        with_assignments! do
          with_csv_row!(row) do
            process_csv_row!
          end
        end
      end

      # @param [Solution, SolutionDraft] instance
      # @return [String]
      def output_csv!(instance)
        with_instance! instance do
          to_csv
        end
      end

      # @!endgroup

      private

      # @param [SolutionProperties::Assignment] assignment
      # @return [void]
      def apply_assignment(assignment)
        if assignment.attribute_name == attribute_name
          apply_value(assignment.value)
        else
          apply_value_to(assignment.attribute_name, assignment.value)
        end
      end

      def apply_value_to(attr, value)
        instance.public_send(:"#{attr}=", value)
      end

      # @param [Object] value
      # @return [void]
      def apply_value(value)
        apply_value_to attribute_name, value
      end

      def assign_value_from_csv!(attribute_name, source_header, skip_missing: true, **options, &)
        options[:csv_header] = source_header
        options[:csv_row] = csv_row

        source_header = source_header.to_sym

        unless has_header?(source_header)
          return if skip_missing

          # :nocov:
          raise "could not find expected header in CSV row: #{source_header}"
          # :nocov:
        end

        skipped, _ = catch_skipped_assignment do
          value = csv_read(source_header, &)

          assign_value! attribute_name, value, **options
        end
      end

      # @param [Symbol] attribute_name
      # @param [Object] value
      # @return [void]
      def assign_value!(attribute_name, value, **options)
        options[:accessor] ||= self
        options[:property] ||= property

        options[:attribute_name] = attribute_name
        options[:value] = value

        assignment = SolutionProperties::Assignment.new(**options)

        assignments << assignment
      end

      def csv_read(source_header)
        raw_value = csv_row.fetch source_header.to_sym

        parsed_value = self.class.csv_parse_type[raw_value.presence]

        return parsed_value unless block_given?

        yield parsed_value
      end

      def has_header?(name)
        name.to_sym.in?(csv_row)
      end

      def look_up_model_term(term)
        Rails.cache.fetch("controlled_vocabularies/#{vocab.name}/#{term}", expires_in: 15.minutes) do
          vocab.model_klass.where(term:).first!
        end
      rescue ActiveRecord::RecordNotFound
        # :nocov:
        return
        # :nocov:
      end

      # @param [<String>] terms
      # @return [String]
      def join_controlled_vocabulary_terms(terms)
        terms.join(TERM_SEPARATOR)
      end

      # @param [String] terms
      # @return [<String>]
      def split_controlled_vocabulary_terms(terms)
        terms.to_s.split(TERM_SPLITTER).compact_blank
      end

      # @return [SolutionProperties::Assignment]
      def with_assignments!
        assigns, _ = with_assignments([]) do
          yield
        end

        return assigns
      end

      # @param [CSV::Row] row
      # @return [void]
      def with_csv_row!(row)
        with_csv_row row do
          yield
        end
      end

      # @param [Solution, SolutionDraft] instance
      # @return [void]
      def with_instance!(instance)
        with_instance(Solutions::Types::AnySolution[instance]) do
          yield
        end
      end

      # @!group Private Interface

      # @param [Object] input
      # @return [Object]
      def process_default_csv_value(input)
        return input
      end

      # @return [void]
      def process_csv_row!
        assign_value_from_csv! attribute_name, csv_header do |input|
          process_default_csv_value input
        end
      end

      # @abstract
      def to_csv
        instance.__send__(attribute_name)
      end

      # @!endgroup

      class << self
        # @param [Dry::Types::Type] type
        # @return [void]
        def parse_with!(type)
          csv_parse_type type
        end

        # @!attribute [r] property_kind
        # @return [SolutionPropertyKind]
        def property_kind
          # :nocov:
          return if property_kind_name.blank?
          # :nocov:

          @property_kind ||= SolutionPropertyKind.find(property_kind_name)
        end

        # Set the {.property_kind} for this class.
        #
        # @param [SolutionProperties::Types::Kind] kind
        # @return [void]
        def property_kind!(kind)
          property_kind_name kind.to_sym

          property_kind
        end
      end

      module AcceptsInstance
        extend ActiveSupport::Concern

        included do
          option :instance, Solutions::Types::AnySolution
        end
      end
    end
  end
end
