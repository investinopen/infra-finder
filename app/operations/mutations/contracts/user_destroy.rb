# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::UserDestroy
    # @see Mutations::Implementations::UserDestroy
    class UserDestroy < VOGMutations::Contract
      json do
        required(:user).value(:user)
      end

      rule(:user).validate(:check_protected_dependents)
    end
  end
end
