# frozen_string_literal: true

module Mutations
  module Implementations
    # @see Mutations::CommentDestroy
    class CommentDestroy < VOGMutations::Implementation
      use_contract! :comment_destroy

      authorizes! :comment, with: :destroy?

      # @param [Comment] comment
      # @return [void]
      def call(comment:)
        destroy_model! comment, auth: true
      end
    end
  end
end
