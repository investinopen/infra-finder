# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionUpdate
    # @see Mutations::Implementations::SolutionUpdate
    class SolutionUpdate < VOGMutations::Contract
      json do
        required(:solution).value(:solution)
      end
    end
  end
end
