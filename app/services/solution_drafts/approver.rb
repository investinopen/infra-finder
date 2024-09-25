# frozen_string_literal: true

module SolutionDrafts
  # Apply a {SolutionDraft}'s changes to its {Solution}, while also transitioning
  # the draft to the `approved` state.
  #
  # @see SolutionDrafts::Approve
  # @see SolutionDrafts::StateMachine
  class Approver < WorkflowActor
    include InfraFinder::Deps[
      assign_attributes: "solutions.assign_attributes",
    ]

    transitions_to! :approved

    def post_process
      yield assign_attributes.(draft, solution)

      # Auto-publish the solution when approving a draft.
      solution.published!

      yield solution.create_revision(
        kind: :draft,
        solution_draft: draft,
        note: memo,
        user:,
      )

      super
    end
  end
end
