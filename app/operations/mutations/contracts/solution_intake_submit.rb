# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionIntakeSubmit
    # @see Mutations::Implementations::SolutionIntakeSubmit
    class SolutionIntakeSubmit < VOGMutations::Contract
      json do
        required(:solution_intake).value(:solution_intake)
        optional(:note).maybe(:string)
      end
    end
  end
end
