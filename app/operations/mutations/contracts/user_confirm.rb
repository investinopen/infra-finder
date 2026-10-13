# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserConfirm
    # @see Mutations::Implementations::UserConfirm
    class UserConfirm < VOGMutations::Contract
      json do
        required(:confirmation_token).filled(:string)
      end
    end
  end
end
