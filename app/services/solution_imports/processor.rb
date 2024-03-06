# frozen_string_literal: true

module SolutionImports
  # Main processor for the {SolutionImport} subsystem.
  class Processor < Support::HookBased::Actor
    include Dry::Effects::Handler.Interrupt(:mark_invalid, as: :catch_invalid_processing)
    include Dry::Initializer[undefined: false].define -> do
      param :import, Types::SolutionImport
    end

    include MonadicPersistence
    include MonadicTransitions

    standard_execution!

    # @return [SolutionImports::AbstractContext]
    attr_reader :context

    # @return [StoredMessages::Logger]
    attr_reader :logger

    include InfraFinder::Deps[
      build_context: "solution_imports.build_context",
      extract_organizations: "solution_imports.extraction.extract_organizations",
      extract_solutions: "solution_imports.extraction.extract_solutions",
      persist_organizations: "solution_imports.persistence.persist_organizations",
      persist_solutions: "solution_imports.persistence.persist_solutions",
    ]

    delegate :strategy, :user, to: :import
    delegate :wrap_extraction!, :wrap_persistence!, to: :context

    # @return [Dry::Monads::Success(SolutionImport)]
    # @return [Dry::Monads::Failure(:invalid_state, String)]
    def call
      run_callbacks :execute do
        yield check_state!

        yield prepare!

        yield start!
      end

      import.current_state(force_reload: true)

      Success import
    ensure
      logger.try(:persist!)
    end

    wrapped_hook! def check_state
      import.current_state(force_reload: true)

      return Failure[:invalid_state, import.current_state] unless import.in_state?(:pending)

      super
    end

    wrapped_hook! def prepare
      @logger = import.message_logger

      @context = yield build_context.(import, logger:)

      super
    end

    wrapped_hook! def start
      yield monadic_transition import, :started

      logger.debug "Import started"

      match_perform! do |m|
        m.success do
          yield finalize!
        end

        m.failure do
          # :nocov:
          logger.fatal "Import failed, cannot proceed."

          yield monadic_transition(import, :failure)
          # :nocov:
        end
      end

      super
    end

    wrapped_hook! def perform
      yield extract!

      yield persist!

      super
    end

    wrapped_hook! def extract
      yield extract_organizations.()
      yield extract_solutions.()

      super
    end

    wrapped_hook! def persist
      yield persist_organizations.()
      yield persist_solutions.()

      super
    end

    wrapped_hook! def finalize
      import.assign_attributes(context.to_finalize)

      import.save!

      logger.info "Import complete."

      yield monadic_transition(import, :success)

      super
    end

    around_execute :track_invalid!

    around_extract :wrap_extraction!

    around_persist :wrap_persistence!

    private

    # @return [void]
    def track_invalid!
      halted, reason = catch_invalid_processing do
        yield
      end

      return unless halted

      monadic_transition(import, "invalid", reason:).value!

      logger.fatal "Import halting because it was found to be invalid: #{reason}"

      logger.persist!
    end
  end
end
