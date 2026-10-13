# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserSignIn
    # @see Mutations::Implementations::UserSignIn
    class UserSignIn < VOGMutations::Contract
      json do
        required(:email).filled(:string)
        required(:password).filled(:string)
      end
    end
  end
end
