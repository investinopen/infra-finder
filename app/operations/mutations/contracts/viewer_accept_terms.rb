# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ViewerAcceptTerms
    # @see Mutations::Implementations::ViewerAcceptTerms
    class ViewerAcceptTerms < VOGMutations::Contract
      json do
        required(:accept_terms_and_conditions).value(:bool)
      end

      rule(:accept_terms_and_conditions) do
        key.failure(:must_be_accepted) unless value
      end
    end
  end
end
