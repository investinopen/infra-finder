# frozen_string_literal: true

module Types
  # @see Provider
  class ProviderType < Types::AbstractModel
    description <<~TEXT
    The organization that provides one or more solutions.
    TEXT

    field :name, String, null: false do
      description "The provider's name."
    end

    field :url, String, null: true do
      description "The provider's website."
    end

    field :url_slug, String, null: false, method: :slug do
      description "The provider's human-readable slug, as used in public URLs."
    end

    field :solutions_count, Integer, null: false do
      description "The number of solutions this provider has."
    end

    field :editor_assignments, resolver: ::Resolvers::ProviderEditorAssignmentResolver do
      description "The users who can edit this provider's solutions."
    end

    field :assignable_users, resolver: ::Resolvers::AssignableUserResolver do
      description "Users who can be made editors of this provider: not admins, and not already its editors."
    end

    field :invitations, resolver: ::Resolvers::InvitationResolver do
      description "Invitations sent for this provider."
    end
  end
end
