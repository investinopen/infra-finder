# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {Comment} with {::Types::CommentOrderType}.
  module OrderedAsComment
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::CommentOrderType, default: "DEFAULT"
    end
  end
end
