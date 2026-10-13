# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::ViewerSignOut
  class ViewerSignOut < Mutations::BaseMutation
    description <<~TEXT
    Revoke the bearer token used for this request. Other devices stay signed in.
    TEXT

    field :signed_out, Boolean, null: true do
      description "Whether the token was revoked."
    end

    performs_operation! "mutations.implementations.viewer_sign_out"
  end
end
