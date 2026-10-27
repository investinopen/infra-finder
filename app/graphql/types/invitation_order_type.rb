# frozen_string_literal: true

module Types
  # @see Resolvers::OrderedAsInvitation
  class InvitationOrderType < Types::BaseEnum
    description <<~TEXT
    Sort a collection of `Invitation` records by specific properties and directions.
    TEXT

    value "DEFAULT" do
      description "Sort invitations by most recently updated."
    end

    value "RECENT" do
      description "Sort invitations by newest created date."
    end

    value "OLDEST" do
      description "Sort invitations by oldest created date."
    end
  end
end
