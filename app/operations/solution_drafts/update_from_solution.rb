# frozen_string_literal: true

module SolutionDrafts
  # Copy a {SolutionDraft}'s {Solution} values into every property the draft has not overridden.
  #
  # Drafts that are no longer pending or in review are left alone.
  class UpdateFromSolution
    include Dry::Monads[:result, :do]

    include InfraFinder::Deps[
      assign_attributes: "solutions.assign_attributes",
    ]

    # @param [SolutionDraft] draft
    # @return [Dry::Monads::Success(SolutionDraft)]
    # @return [Dry::Monads::Failure(:invalid_draft, SolutionDraft)]
    def call(draft)
      return Success draft unless draft.mutable? && draft.solution.present?

      # Association writers save immediately, so roll back the whole draft on failure.
      ApplicationRecord.transaction do
        yield assign_attributes.(draft.solution, draft)
      end

      Success draft
    rescue ActiveRecord::RecordInvalid
      Failure[:invalid_draft, draft]
    end
  end
end
