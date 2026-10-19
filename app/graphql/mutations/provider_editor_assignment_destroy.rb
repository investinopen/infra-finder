# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ProviderEditorAssignmentDestroy
  class ProviderEditorAssignmentDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `ProviderEditorAssignment` record.
    TEXT

    argument :provider_editor_assignment_id, ID, loads: Types::ProviderEditorAssignmentType, required: true do
      description <<~TEXT
      The provider editor assignment to destroy.
      TEXT
    end

    performs_operation! "mutations.implementations.provider_editor_assignment_destroy", destroy: true
  end
end
