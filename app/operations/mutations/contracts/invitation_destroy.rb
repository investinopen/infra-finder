# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::InvitationDestroy
    # @see Mutations::Implementations::InvitationDestroy
    class InvitationDestroy < VOGMutations::Contract
      json do
        required(:invitation).value(:invitation)
      end

      rule(:invitation).validate(:check_protected_dependents)
    end
  end
end
