# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::CommentCreate
    # @see Mutations::Implementations::CommentCreate
    class CommentCreate < VOGMutations::Contract
      json do
        required(:body).filled(:string)
      end
    end
  end
end
