# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::InvitationCreate
    # @see Mutations::Implementations::InvitationCreate
    class InvitationCreate < VOGMutations::Contract
      json do
        required(:provider).value(:provider)
        required(:email).filled(:string)
        required(:first_name).filled(:string)
        required(:last_name).filled(:string)
      end
    end
  end
end
