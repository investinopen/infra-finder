# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserUnlock
    # @see Mutations::Implementations::UserUnlock
    class UserUnlock < VOGMutations::Contract
      json do
        required(:unlock_token).filled(:string)
      end
    end
  end
end
