# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ProviderCreate
    # @see Mutations::Implementations::ProviderCreate
    class ProviderCreate < VOGMutations::Contract
      json do
        required(:name).filled(:string)
      end
    end
  end
end
