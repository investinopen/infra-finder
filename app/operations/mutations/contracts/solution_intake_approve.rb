# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionIntakeApprove
    # @see Mutations::Implementations::SolutionIntakeApprove
    class SolutionIntakeApprove < VOGMutations::Contract
      json do
        required(:solution_intake).value(:solution_intake)
        optional(:note).maybe(:string)
      end
    end
  end
end
