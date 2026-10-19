# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ProviderDestroy
    # @see Mutations::Implementations::ProviderDestroy
    class ProviderDestroy < VOGMutations::Contract
      json do
        required(:provider).value(:provider)
      end

      rule(:provider).validate(:check_protected_dependents)
    end
  end
end
