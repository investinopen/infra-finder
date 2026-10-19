# frozen_string_literal: true

module Types
  # @see Commentable
  module CommentableType
    include Types::BaseInterface

    description <<~TEXT
    A record that admins and editors can leave comments on.
    TEXT

    field :comments, resolver: ::Resolvers::CommentResolver do
      description "The comments on this record that the viewer may see."
    end

    field :can_create_comment, Boolean, null: false do
      description "Whether the viewer may comment on this record. Used by the `commentCreate` mutation."
    end

    # @return [Boolean]
    def can_create_comment
      allowed_to?(:create?, ::Comment.new(resource: object))
    end
  end
end
