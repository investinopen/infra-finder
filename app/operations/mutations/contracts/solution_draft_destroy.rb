# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionDraftDestroy
    # @see Mutations::Implementations::SolutionDraftDestroy
    class SolutionDraftDestroy < VOGMutations::Contract
      json do
        required(:solution_draft).value(:solution_draft)
      end

      rule(:solution_draft).validate(:check_protected_dependents)
    end
  end
end
