# frozen_string_literal: true

module Types
  # @see User#kind
  class UserKindType < Types::BaseEnum
    description <<~TEXT
    The kind of access a user has, derived from their roles and assignments.
    TEXT

    value "SUPER_ADMIN", value: "super_admin" do
      description "A super admin, who can manage everything."
    end

    value "ADMIN", value: "admin" do
      description "An admin."
    end

    value "EDITOR", value: "editor" do
      description "An editor for at least one provider."
    end

    value "UNASSIGNED", value: "unassigned" do
      description "A user with no admin role or editor assignment."
    end
  end
end
