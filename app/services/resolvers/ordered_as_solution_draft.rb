# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {SolutionDraft} with {::Types::SolutionDraftOrderType}.
  module OrderedAsSolutionDraft
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::SolutionDraftOrderType, default: "DEFAULT"
    end
  end
end
