# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionCreateDraft
    # @see Mutations::Implementations::SolutionCreateDraft
    class SolutionCreateDraft < VOGMutations::Contract
      json do
        required(:solution).value(:solution)
      end
    end
  end
end
