# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ProviderUpdate
    # @see Mutations::Implementations::ProviderUpdate
    class ProviderUpdate < VOGMutations::Contract
      json do
        required(:provider).value(:provider)
      end
    end
  end
end
