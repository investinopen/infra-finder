# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {User} with {::Types::UserOrderType}.
  module OrderedAsUser
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::UserOrderType, default: "DEFAULT"
    end

    order_pair! :email
  end
end
