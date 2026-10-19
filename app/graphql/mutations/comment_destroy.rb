# frozen_string_literal: true

module Mutations
  # @see Mutations::Implementations::CommentDestroy
  class CommentDestroy < Mutations::BaseMutation
    description <<~TEXT
    Destroy a single `Comment` record.
    TEXT

    argument :comment_id, ID, loads: Types::CommentType, required: true do
      description <<~TEXT
      The comment to destroy.
      TEXT
    end

    performs_operation! "mutations.implementations.comment_destroy", destroy: true
  end
end
