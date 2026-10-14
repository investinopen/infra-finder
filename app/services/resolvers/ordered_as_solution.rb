# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {Solution} with {::Types::SolutionOrderType}.
  module OrderedAsSolution
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::SolutionOrderType, default: "DEFAULT"
    end
  end
end
