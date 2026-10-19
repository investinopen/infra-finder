# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ProviderEditorAssignmentDestroy
    # @see Mutations::Implementations::ProviderEditorAssignmentDestroy
    class ProviderEditorAssignmentDestroy < VOGMutations::Contract
      json do
        required(:provider_editor_assignment).value(:provider_editor_assignment)
      end

      rule(:provider_editor_assignment).validate(:check_protected_dependents)
    end
  end
end
