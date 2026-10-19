# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionDraftApprove
    # @see Mutations::Implementations::SolutionDraftApprove
    class SolutionDraftApprove < VOGMutations::Contract
      json do
        required(:solution_draft).value(:solution_draft)
        optional(:memo).maybe(:string)
      end
    end
  end
end
