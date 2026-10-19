# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionDraftReject
    # @see Mutations::Implementations::SolutionDraftReject
    class SolutionDraftReject < VOGMutations::Contract
      json do
        required(:solution_draft).value(:solution_draft)
        optional(:memo).maybe(:string)
      end
    end
  end
end
