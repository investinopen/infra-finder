# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserRequestPasswordReset
    # @see Mutations::Implementations::UserRequestPasswordReset
    class UserRequestPasswordReset < VOGMutations::Contract
      json do
        required(:email).filled(:string)
      end

      rule(:email).validate(:email_format)
    end
  end
end
