# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionIntakeUpdate
    # @see Mutations::Implementations::SolutionIntakeUpdate
    class SolutionIntakeUpdate < VOGMutations::Contract
      json do
        required(:solution_intake).value(:solution_intake)
      end
    end
  end
end
