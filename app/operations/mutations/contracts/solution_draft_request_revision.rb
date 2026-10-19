# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionDraftRequestRevision
    # @see Mutations::Implementations::SolutionDraftRequestRevision
    class SolutionDraftRequestRevision < VOGMutations::Contract
      json do
        required(:solution_draft).value(:solution_draft)
        optional(:memo).maybe(:string)
      end
    end
  end
end
