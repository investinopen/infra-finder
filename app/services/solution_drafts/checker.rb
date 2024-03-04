# frozen_string_literal: true

module SolutionDrafts
  # Check a {SolutionDraft} and update its changes against its parent {Solution}.
  #
  # @see SolutionDrafts::Check
  class Checker < Support::HookBased::Actor
    include Dry::Initializer[undefined: false].define -> do
      param :draft, Types::Draft
    end

    standard_execution!

    include InfraFinder::Deps[
      compare_attributes: "solutions.compare_attributes",
    ]

    delegate :mutable?, :solution, to: :draft

    # @return [ActiveSupport::HashWithIndifferentAccess]
    attr_reader :changes

    # @return [<String>]
    attr_reader :draft_overrides

    def call
      run_callbacks :execute do
        yield prepare!

        yield persist!
      end

      Success draft
    end

    wrapped_hook! def prepare
      # :nocov:
      return Failure[:unassociated_draft] if solution.blank?
      # :nocov:

      @changes = yield compare_to_solution

      @draft_overrides = mutable? ? changes.keys.sort : draft.draft_overrides

      super
    end

    wrapped_hook! def persist
      draft.update_columns(draft_overrides:) if mutable?

      super
    end

    private

    def compare_to_solution
      if mutable?
        compare_attributes.(solution, draft)
      else
        Success({})
      end
    end
  end
end
