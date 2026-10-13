# frozen_string_literal: true

module Types
  # @see ProviderEditorAssignment
  class ProviderEditorAssignmentType < Types::AbstractModel
    description <<~TEXT
    Grants a user editor access to a provider's solutions.
    TEXT

    field :provider, "::Types::ProviderType", null: false do
      description "The provider the user can edit for."
    end

    field :user, "::Types::UserType", null: false do
      description "The editor."
    end

    load_association! :provider
    load_association! :user
  end
end
