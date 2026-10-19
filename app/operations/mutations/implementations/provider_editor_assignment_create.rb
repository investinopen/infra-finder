# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::ProviderEditorAssignmentCreate
    class ProviderEditorAssignmentCreate < VOGMutations::Implementation
      use_contract! :provider_editor_assignment_create

      authorizes! :provider_editor_assignment, with: :create?

      # @param [ProviderEditorAssignment] provider_editor_assignment
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(provider_editor_assignment:, **attrs)
        assign_attributes!(provider_editor_assignment, **attrs)

        persist_model! provider_editor_assignment, attach_to: :provider_editor_assignment
      end

      before_prepare def initialize_provider_editor_assignment!
        args[:provider_editor_assignment] = ProviderEditorAssignment.new
      end
    end
  end
end
