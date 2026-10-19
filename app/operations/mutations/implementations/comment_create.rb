# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::CommentCreate
    class CommentCreate < VOGMutations::Implementation
      use_contract! :comment_create

      authorizes! :comment, with: :create?

      # @param [Comment] comment
      # @param [{ Symbol => Object }] attrs
      # @return [void]
      def call(comment:, **attrs)
        assign_attributes!(comment, **attrs)

        persist_model! comment, attach_to: :comment

        check_result! call_operation("admin.notify_comment", comment, verb: :create)
      end

      before_prepare def initialize_comment!
        args[:comment] = Comment.new(resource: args[:commentable])

        args[:comment].author = current_user unless current_user.anonymous?
      end
    end
  end
end
