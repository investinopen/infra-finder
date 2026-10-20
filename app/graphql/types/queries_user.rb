# frozen_string_literal: true

module Types
  # An interface for querying {User}.
  module QueriesUser
    include Types::BaseInterface

    description <<~TEXT
    An interface for querying `User` records.
    TEXT

    field :upload_access, Types::UploadAccessType, null: true do
      description "Display upload access information for the current user."
    end

    field :viewer, Types::UserType, null: false, terms_exempt: true do
      description <<~TEXT
      The currently authenticated user. AKA: you
      TEXT
    end

    field :user, ::Types::UserType, null: true do
      description <<~TEXT
      Retrieve a single `User` by slug.
      TEXT

      argument :slug, Types::SlugType, required: true do
        description <<~TEXT
        The slug to look up.
        TEXT
      end
    end

    field :users, resolver: ::Resolvers::UserResolver

    # @param [String] slug
    # @return [User, nil]
    def user(slug:)
      load_record_with(User, slug)
    end

    # @return [Users::UploadAccess]
    def upload_access = Users::UploadAccess.new(context[:current_user], session_id: context[:access_token]&.session_id)

    # @return [User, AnonymousUser]
    def viewer
      context[:current_user] || AnonymousUser.new
    end
  end
end
