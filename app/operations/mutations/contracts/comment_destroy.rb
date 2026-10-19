# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::CommentDestroy
    # @see Mutations::Implementations::CommentDestroy
    class CommentDestroy < VOGMutations::Contract
      json do
        required(:comment).value(:comment)
      end

      rule(:comment).validate(:check_protected_dependents)
    end
  end
end
