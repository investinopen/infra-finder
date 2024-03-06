# frozen_string_literal: true

module Solutions
  # Create a {SolutionDraft} from a {Solution}.
  class DraftCreator < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :solution, Types::Actual

      option :enforce_single_pending_draft, Types::Bool, default: proc { true }

      option :user, Types::User.optional, optional: true
    end

    # @return [SolutionDraft]
    attr_reader :draft

    standard_execution!

    include InfraFinder::Deps[
      assign_attributes: "solutions.assign_attributes",
    ]

    # @return [Dry::Monads::Success(SolutionDraft)]
    def call
      run_callbacks :execute do
        yield prepare!

        yield assign!
      end

      Success draft
    end

    wrapped_hook! def prepare
      if enforce_single_pending_draft
        @draft = solution.solution_drafts.in_state(:pending).where(user:).first_or_initialize

        return Failure[:pending_draft_exists, draft] if draft.persisted?
      else
        @draft = solution.solution_drafts.build(user:)
      end

      super
    end

    wrapped_hook! def assign
      yield assign_attributes.(solution, draft)

      super
    end
  end
end
