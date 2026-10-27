# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {Provider} with {::Types::ProviderOrderType}.
  module OrderedAsProvider
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::ProviderOrderType, default: "DEFAULT"
    end

    # @param [ActiveRecord::Relation<Provider>] scope
    # @return [ActiveRecord::Relation<Provider>]
    def apply_order_with_solutions_count_ascending(scope)
      scope.lazily_order(:solutions_count, :asc).lazily_order(:name, :asc)
    end

    # @see #apply_order_with_solutions_count_ascending
    # @param [ActiveRecord::Relation<Provider>] scope
    # @return [ActiveRecord::Relation<Provider>]
    def apply_order_with_solutions_count_descending(scope)
      scope.lazily_order(:solutions_count, :desc).lazily_order(:name, :asc)
    end
  end
end
