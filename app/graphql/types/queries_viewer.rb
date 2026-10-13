# frozen_string_literal: true

module Types
  # Queries about the current viewer.
  module QueriesViewer
    include Types::BaseInterface

    description <<~TEXT
    Queries about the current viewer.
    TEXT

    field :upload_access, Types::UploadAccessType, null: true do
      description "Display upload access information for the current user."
    end

    field :viewer, Types::UserType, null: false, terms_exempt: true do
      description <<~TEXT
      The currently authenticated user. AKA: you
      TEXT
    end

    # @return [Users::UploadAccess]
    def upload_access = Users::UploadAccess.new(context[:current_user], session_jti: context[:token_payload]&.dig("jti"))

    # @return [User, AnonymousUser]
    def viewer
      context[:current_user] || AnonymousUser.new
    end
  end
end
