# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ViewerUpdate
  class ViewerUpdate < Mutations::BaseMutation
    description <<~TEXT
    Update the currently authenticated viewer's profile.
    TEXT

    field :user, Types::UserType, null: true do
      description <<~TEXT
      The newly-modified viewer, if successful.
      TEXT
    end

    shared_argument_set Mutations::Shared::UserData

    argument :current_password, String, required: false, transient: true do
      description <<~TEXT
      The current password of the viewer.

      It must be provided when changing the password or the email.
      TEXT
    end

    performs_operation! "mutations.implementations.viewer_update"
  end
end
