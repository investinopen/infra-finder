# frozen_string_literal: true

module Types
  # An interface for querying {Invitation}.
  module QueriesInvitation
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `Invitation` records.
    TEXT

    field :invitation, ::Types::InvitationType, null: true do
      description <<~TEXT
      Retrieve a single `Invitation` by slug.
      TEXT

      argument :slug, Types::SlugType, required: true do
        description <<~TEXT
        The slug to look up.
        TEXT
      end
    end

    field :invitations, resolver: ::Resolvers::InvitationResolver

    # @param [String] slug
    # @return [Invitation, nil]
    def invitation(slug:)
      load_record_with(Invitation, slug)
    end
  end
end
