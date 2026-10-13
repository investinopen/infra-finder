# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {Invitation} with {::Types::InvitationOrderType}.
  module OrderedAsInvitation
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::InvitationOrderType, default: "DEFAULT"
    end
  end
end
