# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ProviderEditorAssignmentDestroy
    class ProviderEditorAssignmentDestroy < VOGMutations::Implementation
      use_contract! :provider_editor_assignment_destroy

      authorizes! :provider_editor_assignment, with: :destroy?

      # @param [ProviderEditorAssignment] provider_editor_assignment
      # @return [void]
      def call(provider_editor_assignment:)
        destroy_model! provider_editor_assignment, auth: true
      end
    end
  end
end
