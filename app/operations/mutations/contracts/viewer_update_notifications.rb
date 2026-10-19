# frozen_string_literal: true

module Mutations
  module Contracts
    # @see Mutations::ViewerUpdateNotifications
    # @see Mutations::Implementations::ViewerUpdateNotifications
    class ViewerUpdateNotifications < VOGMutations::Contract
      json do
        optional(:comment_notifications).filled(:string)
        optional(:solution_notifications).filled(:string)
      end
    end
  end
end
