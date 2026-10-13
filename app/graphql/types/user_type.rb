# frozen_string_literal: true

module Types
  # A known or anonymous user in the system.
  class UserType < Types::AbstractModel
    description <<~TEXT
    A known or anonymous user in the system.
    TEXT

    field :anonymous, Boolean, null: false, method: :anonymous? do
      description "Is this an anonymous / unauthenticated user?"
    end

    field :email, String, null: true do
      description "The user's email address."
    end

    field :name, String, null: true do
      description "The user's display name."
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

    field :upload_access, Boolean, null: false, method: :has_any_upload_access? do
      description "Whether the user may upload files."
    end
  end
end
