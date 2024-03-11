# frozen_string_literal: true

module SolutionDrafts
  # An abstract hook-based actor that operates as a base class for any/all actors
  # that operate on a single {SolutionDraft}.
  #
  # @abstract
  class BaseActor < Support::HookBased::Actor
    extend Dry::Initializer

    param :draft, Types::Draft

    standard_execution!

    delegate :solution, to: :draft

    include MonadicPersistence
    include MonadicTransitions

    # @return [Dry::Monads::Success(SolutionDraft)]
    def call
      run_callbacks :execute do
        yield enforce_solution!

        yield prepare!

        yield perform!
      end

      Success draft
    end

    wrapped_hook! def enforce_solution
      # :nocov:
      return Failure[:unassociated_draft] if solution.blank?
      # :nocov:

      super
    end

    wrapped_hook! :prepare

    wrapped_hook! :perform

    private

    # @todo Re-investigate why this fails certain updates.
    # @return [void]
    def locked_performance!
      # :nocov:
      ApplicationRecord.transaction do
        draft.lock!
        solution.lock!

        yield
      end
      # :nocov:
    end
  end
end
