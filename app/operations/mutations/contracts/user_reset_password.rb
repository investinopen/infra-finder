# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserResetPassword
    # @see Mutations::Implementations::UserResetPassword
    class UserResetPassword < VOGMutations::Contract
      json do
        required(:reset_password_token).filled(:string)
        required(:password).filled(:string)
        required(:password_confirmation).filled(:string)
      end

      rule(:password_confirmation, :password) do
        key.failure(:must_match_password) if values[:password] != values[:password_confirmation]
      end
    end
  end
end
