# frozen_string_literal: true

module Types
  # @see Users::UploadAccess
  class UploadAccessType < Types::BaseObject
    description <<~TEXT
    Information about upload access for the current user.
    TEXT

    field :token, String, null: true, preauthorize: { to: :upload?, with: Users::UploadAccessPolicy, raise: false } do
      description <<~TEXT
      If the user has any upload access, this token will allow them to do so.
      TEXT
    end

    expose_authorization_rule :upload?, <<~TEXT
    Whether the current user has any upload access.
    TEXT
  end
end
