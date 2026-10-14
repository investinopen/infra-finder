# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {SolutionRevision} with {::Types::SolutionRevisionOrderType}.
  module OrderedAsSolutionRevision
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::SolutionRevisionOrderType, default: "DEFAULT"
    end
  end
end
