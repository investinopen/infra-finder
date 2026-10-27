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

    # @param [ActiveRecord::Relation<User>] scope
    # @return [ActiveRecord::Relation<User>]
    def apply_order_with_recent_sign_in(scope)
      scope.order(User.arel_table[:current_sign_in_at].desc.nulls_last).lazily_order(:name, :asc)
    end

    # @param [ActiveRecord::Relation<User>] scope
    # @return [ActiveRecord::Relation<User>]
    def apply_order_with_oldest_sign_in(scope)
      scope.order(User.arel_table[:current_sign_in_at].asc.nulls_last).lazily_order(:name, :asc)
    end
  end
end
