# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::SolutionDestroy
    # @see Mutations::Implementations::SolutionDestroy
    class SolutionDestroy < VOGMutations::Contract
      json do
        required(:solution).value(:solution)
      end

      rule(:solution).validate(:check_protected_dependents)
    end
  end
end
