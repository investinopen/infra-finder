# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ProviderEditorAssignmentCreate
  class ProviderEditorAssignmentCreate < Mutations::BaseMutation
    description <<~TEXT
    Make a user an editor of a provider's solutions.
    TEXT

    field :provider_editor_assignment, Types::ProviderEditorAssignmentType, null: true do
      description <<~TEXT
      The new assignment, if successful.
      TEXT
    end

    argument :provider_id, ID, loads: Types::ProviderType, required: true do
      description "The provider whose solutions the user can edit."
    end

    argument :user_id, ID, loads: Types::UserType, required: true do
      description "The user to make an editor. `Provider.assignableUsers` lists users who are not admins and not already editors of the provider."
    end

    performs_operation! "mutations.implementations.provider_editor_assignment_create"
  end
end
