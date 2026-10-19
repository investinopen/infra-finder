# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionIntakeReset
    # @see Mutations::Implementations::SolutionIntakeReset
    class SolutionIntakeReset < VOGMutations::Contract
      json do
        required(:solution_intake).value(:solution_intake)
        optional(:note).maybe(:string)
      end
    end
  end
end
