# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {Solution} with {::Types::SolutionOrderType}.
  module OrderedAsSolution
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::SolutionOrderType, default: "DEFAULT"
    end

    # @param [ActiveRecord::Relation<Solution>] scope
    # @return [ActiveRecord::Relation<Solution>]
    def apply_order_with_empty_properties_count_ascending(scope)
      scope.order(Solution.arel_table[:empty_properties_count].asc.nulls_last).lazily_order(:name, :asc)
    end

    # @param [ActiveRecord::Relation<Solution>] scope
    # @return [ActiveRecord::Relation<Solution>]
    def apply_order_with_empty_properties_count_descending(scope)
      scope.order(Solution.arel_table[:empty_properties_count].desc.nulls_last).lazily_order(:name, :asc)
    end
  end
end
