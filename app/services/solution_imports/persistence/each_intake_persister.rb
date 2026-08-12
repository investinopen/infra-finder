# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist a single transient {Solution} record from an import source.
    #
    # @see SolutionImports::Persistence::PersistEachIntake
    class EachIntakePersister < SolutionImports::Persistence::BasePersister
      include EachPersister

      param :intake_row, SolutionImports::Transient::IntakeRow::Type

      delegate :provider_identifier, :identifier, to: :intake_row

      # @return [SolutionIntake]
      attr_reader :intake

      # @return [Dry::Monads::Success(SolutionIntake)]
      def call
        super

        Success intake
      end

      def prepare
        @provider = yield maybe_find_provider

        @intake = yield find_or_initialize_intake

        logger.debug "Preparing intake"

        super
      end

      def perform
        yield prepare_intake!

        yield populate_intake!

        yield handle_attachments!

        super
      end

      wrapped_hook! def prepare_intake
        # Ensure our intake is persisted
        intake.save!

        intake.add_imported_tag!

        super
      end

      wrapped_hook! def populate_intake
        intake_row.standard_assignments.each do |assignment|
          assignment.assign! intake
        end

        intake.save!

        super
      rescue ActiveRecord::RecordInvalid => e
        # :nocov:
        mark_invalid "Problem saving record: #{e.message}"
        # :nocov:
      end

      wrapped_hook! def handle_attachments
        intake_row.attachment_assignments.each do |assignment|
          try_attachment! intake, assignment
        end

        super
      end

      around_execute :with_logger_tags!
      around_execute :benchmark_execute!, if: :should_benchmark?
      around_prepare_intake :benchmark_intake_preparation!, if: :should_benchmark?
      around_populate_intake :benchmark_intake_population!, if: :should_benchmark?
      around_handle_attachments :benchmark_intake_attachment_handling!, if: :should_benchmark?

      private

      # @return [void]
      def benchmark_execute!
        benchmark "Solution #{intake_row.name.inspect} persisted.", level: :debug do
          yield
        end
      end

      # @return [void]
      def benchmark_intake_attachment_handling!
        benchmark "Intake attachments handled", level: :debug do
          yield
        end
      end

      # @return [void]
      def benchmark_intake_population!
        benchmark "Intake populated", level: :debug do
          yield
        end
      end

      # @return [void]
      def benchmark_intake_preparation!
        benchmark "Intake prepared", level: :debug do
          yield
        end
      end

      # @return [Dry::Monads::Success(SolutionIntake)]
      def find_or_initialize_intake
        intake = SolutionIntake.new

        intake.assign_attributes(intake_row.attrs_to_create)

        if provider.present?
          intake.provider = provider
        else
          logger.debug("no provider found, will need to manually set")
        end

        Success intake
      end

      # @return [void]
      def with_logger_tags!
        logger.tagged("intake_identifier:#{identifier.inspect}") do
          yield
        end
      end
    end
  end
end
