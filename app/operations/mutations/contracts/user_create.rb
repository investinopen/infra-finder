# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserCreate
    # @see Mutations::Implementations::UserCreate
    class UserCreate < VOGMutations::Contract
      json do
        required(:email).filled(:string)
        required(:name).filled(:string)
        required(:password).filled(:string)
        required(:password_confirmation).filled(:string)
      end
    end
  end
end
