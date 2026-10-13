# frozen_string_literal: true

module Types
  # Queries about the current viewer.
  module QueriesViewer
    include Types::BaseInterface

    description <<~TEXT
    Queries about the current viewer.
    TEXT

    field :viewer, Types::UserType, null: true, terms_exempt: true do
      description "The authenticated user making the request, or null for anonymous requests."
    end

    # @return [User, nil] nil for anonymous requests
    def viewer
      context[:current_user] unless context[:current_user].try(:anonymous?)
    end
  end
end
