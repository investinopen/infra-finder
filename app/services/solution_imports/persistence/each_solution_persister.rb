# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist a single transient {Solution} record from an import source.
    #
    # @see SolutionImports::Persistence::PersistEachSolution
    class EachSolutionPersister < SolutionImports::Persistence::BasePersister
      include EachPersister

      param :solution_row, SolutionImports::Transient::SolutionRow::Type

      delegate :provider_identifier, :identifier, to: :solution_row

      # @return [SolutionDraft]
      attr_reader :draft

      # @return [Boolean]
      attr_reader :new_record

      # @return [Solution]
      attr_reader :solution

      delegate :auto_approve?, to: :import

      # @return [Dry::Monads::Success(Solution)]
      def call
        super

        Success solution
      end

      def prepare
        @provider = yield find_provider

        @solution = yield find_or_initialize_solution

        @new_record = solution.new_record?

        # :nocov:
        if new_record
          logger.debug "Will create a new solution"
        else
          logger.debug "Will update an existing solution: #{solution.id}"
        end
        # :nocov:

        super
      end

      def perform
        yield prepare_draft!

        yield populate_draft!

        yield handle_draft_attachments!

        yield draft.request_review

        # :nocov:
        yield draft.approve if auto_approve?
        # :nocov:

        super
      end

      wrapped_hook! def prepare_draft
        if new_record
          # Ensure our solution is persisted
          solution.save!

          yield solution.create_revision(kind: :import, reason: "Created via solution import ##{import.id}", user:)
        end

        @draft = yield solution.create_draft(user:, enforce_single_pending_draft: false)

        super
      end

      wrapped_hook! def populate_draft
        draft.assign_attributes(solution_row.attrs_to_create)

        solution_row.standard_assignments.each do |assignment|
          assignment.assign! draft
        end

        draft.save!

        draft.add_imported_tag!

        super
      rescue ActiveRecord::RecordInvalid => e
        # :nocov:
        mark_invalid "Problem saving record: #{e.message}"
        # :nocov:
      end

      wrapped_hook! def handle_draft_attachments
        solution_row.attachment_assignments.each do |assignment|
          try_attachment! draft, assignment
        end

        super
      end

      around_execute :with_logger_tags!
      around_execute :benchmark_execute!, if: :should_benchmark?
      around_prepare_draft :benchmark_draft_preparation!, if: :should_benchmark?
      around_populate_draft :benchmark_draft_population!, if: :should_benchmark?
      around_handle_draft_attachments :benchmark_draft_attachment_handling!, if: :should_benchmark?

      private

      # @return [void]
      def benchmark_execute!
        benchmark "Solution #{solution_row.name.inspect} persisted.", level: :debug do
          yield
        end
      end

      # @return [void]
      def benchmark_draft_attachment_handling!
        benchmark "Draft attachments handled", level: :debug do
          yield
        end
      end

      # @return [void]
      def benchmark_draft_population!
        benchmark "Draft populated", level: :debug do
          yield
        end
      end

      # @return [void]
      def benchmark_draft_preparation!
        benchmark "Draft prepared", level: :debug do
          yield
        end
      end

      def find_or_initialize_solution
        solution = Solution.where(identifier:).first_or_initialize do |sol|
          sol.assign_attributes(solution_row.attrs_to_create)
        end

        solution.provider = provider

        Success solution
      end

      # @return [void]
      def with_logger_tags!
        logger.tagged("solution_identifier:#{identifier.inspect}") do
          yield
        end
      end
    end
  end
end
