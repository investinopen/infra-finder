# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserUpdate
    # @see Mutations::Implementations::UserUpdate
    class UserUpdate < VOGMutations::Contract
      json do
        required(:user).value(:user)
      end
    end
  end
end
