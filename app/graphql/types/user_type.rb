# frozen_string_literal: true

module Types
  # A known or anonymous user in the system.
  class UserType < Types::AbstractModel
    description <<~TEXT
    A known or anonymous user in the system.
    TEXT

    implements ::Types::CommentableType

    field :anonymous, Boolean, null: false, method: :anonymous? do
      description "Is this an anonymous / unauthenticated user?"
    end

    field :email, String, null: true do
      description "The user's email address."
    end

    field :unconfirmed_email, String, null: true do
      description "A changed email address that is waiting for the user to confirm it."
    end

    field :name, String, null: true do
      description "The user's display name."
    end

    field :kind, Types::UserKindType, null: true do
      description "The kind of access the user has. Null for anonymous users."
    end

    field :confirmed, Boolean, null: false, method: :confirmed? do
      description "Whether the user has confirmed their email address."
    end

    field :locked, Boolean, null: false, method: :access_locked? do
      description "Whether the account is locked after too many failed sign-in attempts."
    end

    field :sign_in_count, Integer, null: false do
      description "How many times the user has signed in."
    end

    field :current_sign_in_at, GraphQL::Types::ISO8601DateTime, null: true do
      description "When the user's current session began."
    end

    field :last_sign_in_at, GraphQL::Types::ISO8601DateTime, null: true do
      description "When the user's previous session began."
    end

    field :accepted_terms, Boolean, null: false, method: :accepted_terms? do
      description "Whether the user has accepted the terms and conditions."
    end

    field :admin, Boolean, null: false, method: :has_any_admin_access? do
      description "Whether the user has admin access (admins and super admins)."
    end

    field :editor, Boolean, null: false, method: :has_any_editor_access? do
      description "Whether the user is an editor for at least one provider."
    end

    field :super_admin, Boolean, null: false, method: :super_admin? do
      description "Whether the user is a super admin."
    end

    field :comment_notifications, Types::SubscriptionType, null: true do
      description "Whether the user is emailed about comments. Null for anonymous users."
    end

    field :solution_notifications, Types::SubscriptionType, null: true do
      description "Whether the user is emailed about solution workflow changes. Null for anonymous users."
    end

    field :upload_access, Boolean, null: false, method: :has_any_upload_access? do
      description "Whether the user may upload files."
    end

    # @return [String, nil]
    def kind = object.anonymous? ? nil : object.kind

    # @return [String, nil]
    def comment_notifications = object.try(:comment_notifications)

    # @return [String, nil]
    def unconfirmed_email = object.try(:unconfirmed_email)

    # @return [String, nil]
    def solution_notifications = object.try(:solution_notifications)
  end
end
