# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {SolutionImport} with {::Types::SolutionImportOrderType}.
  module OrderedAsSolutionImport
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::SolutionImportOrderType, default: "DEFAULT"
    end
  end
end
