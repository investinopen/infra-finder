# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserResendConfirmation
    # @see Mutations::Implementations::UserResendConfirmation
    class UserResendConfirmation < VOGMutations::Contract
      json do
        required(:email).filled(:string)
      end

      rule(:email).validate(:email_format)
    end
  end
end
