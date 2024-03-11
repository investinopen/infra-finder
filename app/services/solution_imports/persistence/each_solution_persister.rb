# frozen_string_literal: true

module SolutionImports
  module Persistence
    # Persist a single transient {Solution} record from an import source.
    #
    # @see SolutionImports::Persistence::PersistEachSolution
    class EachSolutionPersister < SolutionImports::Persistence::BasePersister
      include Dry::Effects.Cache(:persistence)

      param :solution_row, Types.Instance(SolutionImports::Transient::SolutionRow)

      delegate :organization_identifier, :identifier, to: :solution_row

      # @return [SolutionDraft]
      attr_reader :draft

      # @return [Boolean]
      attr_reader :new_record

      # @return [Organization]
      attr_reader :organization

      # @return [Solution]
      attr_reader :solution

      delegate :auto_approve?, to: :import

      def call
        super

        Success solution
      end

      def prepare
        @organization = yield find_organization

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
        yield draft.approve if auto_approve? || new_record
        # :nocov:

        super
      end

      wrapped_hook! def prepare_draft
        # Ensure our solution is persisted
        solution.save!

        @draft = yield solution.create_draft(user:, enforce_single_pending_draft: false)

        super
      end

      wrapped_hook! def populate_draft
        draft.assign_attributes(solution_row.attrs_to_draft)

        draft.save!

        draft.add_imported_tag!

        super
      end

      wrapped_hook! def handle_draft_attachments
        SolutionInterface::ATTACHMENTS.each do |attachment|
          remote_url = :"#{attachment}_remote_url"

          value = solution_row.public_send(remote_url)

          next if value.blank?

          draft.__send__(:"#{remote_url}=", value)

          unless draft.save
            logger.tagged("attachment:#{attachment}") do
              draft.errors.messages_for(attachment).each do |message|
                logger.warn "Ignoring #{attachment} failure: #{message}"
              end
            end

            draft.reload
          end
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

      # @return [Dry::Monads::Success(Organization)]
      # @return [Dry::Monads::Failure(:unknown_organization, String)]
      def find_organization
        organization = cache :organization, organization_identifier do
          Organization.find_by!(identifier: organization_identifier)
        end
      rescue ActiveRecord::RecordNotFound
        # :nocov:
        Failure[:unknown_organization, organization_identifier]
        # :nocov:
      else
        Success organization
      end

      def find_or_initialize_solution
        solution = Solution.where(identifier:).first_or_initialize do |sol|
          sol.assign_attributes(solution_row.attrs_to_create)
        end

        solution.organization = organization

        Success solution
      end

      # @return [void]
      def with_logger_tags!
        logger.tagged("persist_each_solution", "solution_identifier:#{identifier.inspect}") do
          yield
        end
      end
    end
  end
end
