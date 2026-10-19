# frozen_string_literal: true

module Types
  # @see Comment
  class CommentType < Types::AbstractModel
    description <<~TEXT
    A comment left by an admin or editor on a record.
    TEXT

    field :body, String, null: false do
      description "The text of the comment."
    end

    field :author, "::Types::UserType", null: true do
      description "The user who wrote the comment."
    end

    load_association! :author
  end
end
