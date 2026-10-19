# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionDraftUpdate
    # @see Mutations::Implementations::SolutionDraftUpdate
    class SolutionDraftUpdate < VOGMutations::Contract
      json do
        required(:solution_draft).value(:solution_draft)
      end
    end
  end
end
