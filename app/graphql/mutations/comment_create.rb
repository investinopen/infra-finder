# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::CommentCreate
  class CommentCreate < Mutations::BaseMutation
    description <<~TEXT
    Comment on a record. Users subscribed to comment notifications who can see the record are emailed.
    TEXT

    field :comment, Types::CommentType, null: true do
      description <<~TEXT
      The newly-modified comment, if successful.
      TEXT
    end

    argument :commentable_id, ID, loads: Types::CommentableType, required: true, transient: true do
      description "The record to comment on. `canCreateComment` on the record says whether the viewer may."
    end

    argument :body, String, required: true do
      description "The text of the comment."
    end

    performs_operation! "mutations.implementations.comment_create"
  end
end
