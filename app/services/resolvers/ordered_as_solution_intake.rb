# frozen_string_literal: true

module Resolvers
  # A concern for resolvers that order {SolutionIntake} with {::Types::SolutionIntakeOrderType}.
  module OrderedAsSolutionIntake
    extend ActiveSupport::Concern

    include ::Resolvers::AbstractOrdering

    included do
      orders_with! ::Types::SolutionIntakeOrderType, default: "DEFAULT"
    end
  end
end
