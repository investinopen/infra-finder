# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserSendResetPasswordInstructions
    # @see Mutations::Implementations::UserSendResetPasswordInstructions
    class UserSendResetPasswordInstructions < VOGMutations::Contract
      json do
        required(:user).value(:user)
      end
    end
  end
end
