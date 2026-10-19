# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ProviderEditorAssignmentCreate
    # @see Mutations::Implementations::ProviderEditorAssignmentCreate
    class ProviderEditorAssignmentCreate < VOGMutations::Contract
      json do
        required(:provider).value(:provider)
        required(:user).value(:user)
      end
    end
  end
end
